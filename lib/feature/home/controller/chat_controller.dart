import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import 'home_controller.dart';

/// Extension to normalize coach names (e.g., "Business" -> "Business Coach")
extension CoachDisplay on CoachModel {
  String get displayName =>
      name.trim().toLowerCase().endsWith('coach')
          ? name.trim()
          : '${name.trim()} Coach';
}

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
  static ChatController get to => Get.isRegistered<ChatController>()
      ? Get.find<ChatController>()
      : Get.put(ChatController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  final RxString currentSessionId = ''.obs;
  final Rx<CoachModel?> currentCoach = Rx<CoachModel?>(null);

  /// Selects a coach for a NEW conversation.
  void selectCoach(CoachModel coach) {
    if (currentCoach.value?.id == coach.id && currentSessionId.value.isEmpty) return;
    currentCoach.value = coach;
    currentSessionId.value = '';
    messages.clear();
  }

  /// ✅ Opens an EXISTING chat session from history.
  Future<void> selectChat(String sessionId, CoachModel coach) async {
    currentSessionId.value = sessionId;
    currentCoach.value = coach;
    messages.clear();
    await fetchMessages();
  }

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

  Future<void> openSession(String sessionId, {CoachModel? coach}) async {
    currentSessionId.value = sessionId;
    currentCoach.value = coach;
    messages.clear();
    await fetchMessages();
  }

  Future<void> fetchMessages() async {
    if (currentSessionId.value.isEmpty) return;
    isLoading.value = true;
    try {
      final response =
      await _apiClient.get(ApiEndpoint.chatMessages(currentSessionId.value));
      final list = (response as List?) ?? [];
      messages.value = list
          .map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Could not load messages.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || isSending.value) return;

    final coach = currentCoach.value;
    if (coach == null) {
      Get.snackbar('Select a coach', 'Choose a coach at the top of the chat first.');
      return;
    }

    isSending.value = true;
    try {
      if (currentSessionId.value.isEmpty) {
        final id = await startNewChat(coach);
        if (id == null) return;
      }

      final optimisticMsg = ChatMessageModel(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        role: 'user',
        content: trimmed,
        createdAt: DateTime.now(),
      );
      messages.add(optimisticMsg);

      try {
        final response = await _apiClient.post(
          ApiEndpoint.chatMessages(currentSessionId.value),
          body: {'content': trimmed},
        );
        final list = (response as List?) ?? [];
        final parsed = list
            .map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>))
            .toList();

        messages.removeWhere((m) => m.id == optimisticMsg.id);
        messages.addAll(parsed);
      } on ForbiddenException catch (e) {
        messages.removeWhere((m) => m.id == optimisticMsg.id);
        Get.snackbar('Limit reached', e.message);
      } on HttpException catch (e) {
        Get.snackbar('Error', e.message);
      } catch (e) {
        messages.removeWhere((m) => m.id == optimisticMsg.id);
        Get.snackbar('Error', 'Message failed to send. Please try again.');
      }
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