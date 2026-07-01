// lib/feature/saved/controller/saved_controller.dart

import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../home/controller/home_controller.dart'; // CoachModel

class SavedMessageModel {
  final String id; // saved-record id — use THIS to unsave
  final String messageId;
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

  // The saved-list response shape isn't in the Postman examples, so this
  // parses defensively: it supports a nested payload
  //   { id, message:{id,content,created_at}, session:{id,title}, coach:{...} }
  // as well as a flat one { id, message_id, content, session_id, ... }.
  factory SavedMessageModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>?;
    final session = json['session'] as Map<String, dynamic>?;
    final coachJson = json['coach'] as Map<String, dynamic>?;

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
  static SavedController get to => Get.put(SavedController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;
  final RxList<SavedMessageModel> items = <SavedMessageModel>[].obs;
  final RxString query = ''.obs;

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

  // ─────────────────────────────────────────────────────────────────
  // GET /app/saved/
  // ─────────────────────────────────────────────────────────────────
  Future<void> fetchSaved() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoint.saved);
      // May be a bare list or a paginated { results: [...] }.
      final list = response is List
          ? response
          : (response is Map<String, dynamic>
          ? (response['results'] as List? ?? [])
          : []);
      items.value = list
          .map((e) => SavedMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Could not load saved items.');
    } finally {
      isLoading.value = false;
    }
  }

  bool isSaved(String messageId) => items.any((s) => s.messageId == messageId);

  SavedMessageModel? _byMessageId(String messageId) {
    for (final s in items) {
      if (s.messageId == messageId) return s;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // POST /app/saved/   { message_id }
  // 400 → user message / already saved · 404 → not found / not yours
  // ─────────────────────────────────────────────────────────────────
  Future<bool> saveMessage(String messageId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoint.saved,
        body: {'message_id': messageId},
      );
      if (response is Map<String, dynamic>) {
        items.insert(0, SavedMessageModel.fromJson(response));
      } else {
        await fetchSaved();
      }
      return true;
    } on HttpException catch (e) {
      Get.snackbar('Could not save', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Could not save message.');
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // DELETE /app/saved/{savedId}/   (optimistic, rolls back on failure)
  // ─────────────────────────────────────────────────────────────────
  Future<bool> unsave(String savedId) async {
    final index = items.indexWhere((s) => s.id == savedId);
    SavedMessageModel? removed;
    if (index != -1) {
      removed = items[index];
      items.removeAt(index);
    }
    try {
      await _apiClient.delete(ApiEndpoint.savedItem(savedId));
      return true;
    } on HttpException catch (e) {
      if (removed != null) items.insert(index, removed);
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      if (removed != null) items.insert(index, removed);
      Get.snackbar('Error', 'Could not remove saved item.');
      return false;
    }
  }

  // Handy for a bookmark toggle on a chat bubble (by message id).
  Future<void> toggleByMessage(String messageId) async {
    final existing = _byMessageId(messageId);
    if (existing != null) {
      await unsave(existing.id);
    } else {
      await saveMessage(messageId);
    }
  }
}