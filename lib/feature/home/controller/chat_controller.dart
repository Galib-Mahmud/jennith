// lib/feature/chat/controllers/chat_controller.dart

import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import 'home_controller.dart';

class ChatMessageModel {
  final String id;
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == 'user';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json['id']?.toString() ?? '',
        role: json['role']?.toString() ?? 'assistant',
        content: json['content']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );
}

class ChatController extends GetxController {
  static ChatController get to => Get.put(ChatController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;     // loading message history
  final RxBool isSending = false.obs;     // sending a new message
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  final RxString currentSessionId = ''.obs;
  final Rx<CoachModel?> currentCoach = Rx<CoachModel?>(null);

  // ─────────────────────────────────────────────────────────────────
  // POST /app/chats/   { coach_id } -> session
  // ─────────────────────────────────────────────────────────────────
  Future<String?> startNewChat(CoachModel coach) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoint.chats,
        body: {'coach_id': coach.id},
      );
      final sessionId = response?['id']?.toString();
      if (sessionId != null) {
        currentSessionId.value = sessionId;
        currentCoach.value = coach;
        messages.clear();
      }
      return sessionId;
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Could not start chat. Please try again.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Open an existing chat session — loads coach + message history.
  // ─────────────────────────────────────────────────────────────────
  Future<void> openSession(String sessionId, {CoachModel? coach}) async {
    currentSessionId.value = sessionId;
    currentCoach.value = coach;
    messages.clear();
    await fetchMessages();
  }

  // GET /app/chats/{id}/messages/
  Future<void> fetchMessages() async {
    if (currentSessionId.value.isEmpty) return;
    isLoading.value = true;
    try {
      final response =
      await _apiClient.get(ApiEndpoint.chatMessages(currentSessionId.value));
      final list = (response as List?) ?? [];
      messages.value =
          list.map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>)).toList();
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Could not load messages.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // POST /app/chats/{id}/messages/  { content } -> [userMsg, assistantMsg]
  // ─────────────────────────────────────────────────────────────────
  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || currentSessionId.value.isEmpty) return;

    // Optimistically show the user's message.
    final optimisticMsg = ChatMessageModel(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      content: trimmed,
      createdAt: DateTime.now(),
    );
    messages.add(optimisticMsg);

    isSending.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoint.chatMessages(currentSessionId.value),
        body: {'content': trimmed},
      );
      final list = (response as List?) ?? [];
      final parsed =
      list.map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>)).toList();

      // Replace the optimistic message with the real saved pair.
      messages.removeWhere((m) => m.id == optimisticMsg.id);
      messages.addAll(parsed);
    } on ForbiddenException catch (e) {
      messages.removeWhere((m) => m.id == optimisticMsg.id);
      Get.snackbar('Limit reached', e.message);
    } on HttpException catch (e) {
      // Keep the user's message visible (per API: it's saved even on 502),
      // but surface the failure clearly.
      Get.snackbar('Error', e.message);
    } catch (e) {
      messages.removeWhere((m) => m.id == optimisticMsg.id);
      Get.snackbar('Error', 'Message failed to send. Please try again.');
    } finally {
      isSending.value = false;
    }
  }

  void clearSession() {
    currentSessionId.value = '';
    currentCoach.value = null;
    messages.clear();
  }
}