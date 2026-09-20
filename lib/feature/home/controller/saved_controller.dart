// lib/feature/saved/controller/saved_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../home/controller/home_controller.dart'; // CoachModel

class SavedMessageModel {
  final String id; // saved-record id — use THIS to unsave (DELETE /app/saved/{id}/)
  final String messageId; // chat message id — use THIS to save (POST /app/saved/)
  final String content;
  final DateTime createdAt; // when it was saved
  final String sessionId;
  final String sessionTitle;
  final CoachModel? coach;

  SavedMessageModel({
    required this.id,
    required this.messageId,
    required this.content,
    required this.createdAt,
    required this.sessionId,
    required this.sessionTitle,
    required this.coach,
  });

  // API shape:
  // { id, message:{id,role,content,created_at}, session:{id,title},
  //   coach:{id,name}, created_at }
  // Also tolerates a flat payload { id, message_id, content, session_id, ... }.
  factory SavedMessageModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? asMap(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : null;

    final message = asMap(json['message']);
    final session = asMap(json['session']);
    final coachJson = asMap(json['coach']);

    return SavedMessageModel(
      id: json['id']?.toString() ?? '',
      messageId: (message?['id'] ?? json['message_id'])?.toString() ?? '',
      content: (message?['content'] ?? json['content'])?.toString() ?? '',
      createdAt: DateTime.tryParse(
        (json['created_at'] ?? message?['created_at'])?.toString() ?? '',
      ) ??
          DateTime.now(),
      sessionId: (session?['id'] ?? json['session_id'])?.toString() ?? '',
      sessionTitle:
      (session?['title'] ?? json['session_title'])?.toString() ?? 'Chat',
      coach: coachJson != null ? CoachModel.fromJson(coachJson) : null,
    );
  }
}

class SavedController extends GetxController {
  // Reuses the registered instance (no new ApiClient / http.Client per access).
  static SavedController get to => Get.isRegistered<SavedController>()
      ? Get.find<SavedController>()
      : Get.put(SavedController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxList<SavedMessageModel> items = <SavedMessageModel>[].obs;
  final RxString query = ''.obs;

  /// Message ids with a save/unsave request in flight (blocks double taps and
  /// lets the bookmark icon show a spinner).
  final RxSet<String> busyMessageIds = <String>{}.obs;

  Future<void>? _loading;

  // Client-side search over content, coach name and session title.
  List<SavedMessageModel> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((s) {
      return s.content.toLowerCase().contains(q) ||
          s.sessionTitle.toLowerCase().contains(q) ||
          (s.coach?.name.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSaved();
  }

  /// Call on logout so the next user never sees this user's saved items.
  void clear() {
    items.clear();
    query.value = '';
    busyMessageIds.clear();
    hasError.value = false;
  }

  // ─────────────────────────────────────────────────────────────────
  // GET /app/saved/   (bare list OR paginated { results, next })
  // Concurrent calls share one request.
  // ─────────────────────────────────────────────────────────────────
  Future<void> fetchSaved({bool silent = false}) =>
      _loading ??= _fetch(silent).whenComplete(() => _loading = null);

  Future<void> _fetch(bool silent) async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final all = <SavedMessageModel>[];
      String? endpoint = ApiEndpoint.saved;
      var pages = 0;

      while (endpoint != null && pages < 20) {
        final response = await _apiClient.get(endpoint);
        pages++;

        List<dynamic> rows = const [];
        String? next;
        if (response is List) {
          rows = response;
        } else if (response is Map<String, dynamic>) {
          rows = (response['results'] as List?) ?? const [];
          next = _relativeNext(response['next']);
        }

        all.addAll(rows
            .whereType<Map>()
            .map((e) => SavedMessageModel.fromJson(Map<String, dynamic>.from(e))));
        endpoint = next;
      }

      items.assignAll(all);
    } on HttpException catch (e) {
      hasError.value = true;
      if (!silent) _error('Error', e.message);
    } catch (_) {
      hasError.value = true;
      if (!silent) _error('Error', 'Could not load saved items.');
    } finally {
      isLoading.value = false;
    }
  }

  // "https://host/api/app/saved/?page=2"  ->  "/app/saved/?page=2"
  String? _relativeNext(dynamic next) {
    if (next is! String || next.isEmpty) return null;
    final uri = Uri.tryParse(next);
    if (uri == null) return null;
    var path = uri.path;
    final basePath = Uri.parse(ApiEndpoint.baseUrl).path; // e.g. "/api"
    if (basePath.isNotEmpty && path.startsWith(basePath)) {
      path = path.substring(basePath.length);
    }
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  bool isSaved(String messageId) => items.any((s) => s.messageId == messageId);

  bool isBusy(String messageId) => busyMessageIds.contains(messageId);

  SavedMessageModel? _byMessageId(String messageId) {
    for (final s in items) {
      if (s.messageId == messageId) return s;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // POST /app/saved/   { message_id }
  // 400 -> user message / already saved · 404 -> not found / not yours
  // ─────────────────────────────────────────────────────────────────
  Future<bool> saveMessage(String messageId) async {
    if (messageId.isEmpty || messageId.startsWith('temp-')) return false;
    if (busyMessageIds.contains(messageId)) return false;
    if (isSaved(messageId)) return true;

    busyMessageIds.add(messageId);
    try {
      final response = await _apiClient.post(
        ApiEndpoint.saved,
        body: {'message_id': messageId},
      );

      if (response is Map<String, dynamic>) {
        final saved = SavedMessageModel.fromJson(response);
        if (!items.any((s) => s.id == saved.id)) items.insert(0, saved);
      } else {
        await fetchSaved(silent: true);
      }
      _toast('Saved');
      return true;
    } on HttpException catch (e) {
      if (e.statusCode == 400) {
        // Possibly "already saved" (list was not loaded yet) -> sync and check.
        await fetchSaved(silent: true);
        if (isSaved(messageId)) return true;
      }
      _error('Could not save', e.message);
      return false;
    } catch (_) {
      _error('Error', 'Could not save message.');
      return false;
    } finally {
      busyMessageIds.remove(messageId);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // DELETE /app/saved/{savedId}/   (optimistic, rolls back on failure)
  // ─────────────────────────────────────────────────────────────────
  Future<bool> unsave(String savedId) async {
    final index = items.indexWhere((s) => s.id == savedId);
    final removed = index == -1 ? null : items[index];

    if (removed != null) {
      if (busyMessageIds.contains(removed.messageId)) return false;
      busyMessageIds.add(removed.messageId);
      items.removeAt(index);
    }

    void rollback() {
      if (removed != null && !items.any((s) => s.id == removed.id)) {
        items.insert(index.clamp(0, items.length).toInt(), removed);
      }
    }

    try {
      await _apiClient.delete(ApiEndpoint.savedItem(savedId));
      _toast(
        'Removed from saved',
        onUndo: removed == null ? null : () => saveMessage(removed.messageId),
      );
      return true;
    } on NotFoundException {
      return true; // already deleted on the server — the goal is reached
    } on HttpException catch (e) {
      rollback();
      _error('Error', e.message);
      return false;
    } catch (_) {
      rollback();
      _error('Error', 'Could not remove saved item.');
      return false;
    } finally {
      if (removed != null) busyMessageIds.remove(removed.messageId);
    }
  }

  // Bookmark toggle on a chat bubble (by chat message id).
  Future<void> toggleByMessage(String messageId) async {
    final existing = _byMessageId(messageId);
    if (existing != null) {
      await unsave(existing.id);
    } else {
      await saveMessage(messageId);
    }
  }

  // ─── Feedback ─────────────────────────────────────────────────────
  void _error(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message, snackPosition: SnackPosition.TOP);
  }

  void _toast(String message, {VoidCallback? onUndo}) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      // Sits above the floating bottom-nav pill.
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      borderRadius: 12,
      backgroundColor: const Color(0xFF1A1A1A),
      isDismissible: true,
      mainButton: onUndo == null
          ? null
          : TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          onUndo();
        },
        child: const Text(
          'UNDO',
          style: TextStyle(
            color: Color(0xFFD4A843),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ));
  }
}