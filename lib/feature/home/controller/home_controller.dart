// lib/feature/home/controllers/home_controller.dart

import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

class CoachModel {
  final String id;
  final String name;
  final String tagline;
  final String icon;
  final String accentColor;

  CoachModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.accentColor,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) => CoachModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    tagline: json['tagline']?.toString() ?? '',
    icon: json['icon']?.toString() ?? '',
    accentColor: json['accent_color']?.toString() ?? '#D4A843',
  );
}

class RecentChatModel {
  final String id;
  final CoachModel coach;
  final String title;
  final String? lastMessage;
  final DateTime updatedAt;

  RecentChatModel({
    required this.id,
    required this.coach,
    required this.title,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory RecentChatModel.fromJson(Map<String, dynamic> json) {
    final lastMsg = json['last_message'] as Map<String, dynamic>?;
    return RecentChatModel(
      id: json['id']?.toString() ?? '',
      coach: CoachModel.fromJson(json['coach'] ?? {}),
      title: json['title']?.toString() ?? 'New Chat',
      lastMessage: lastMsg?['content']?.toString(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class HomeController extends GetxController {
  static HomeController get to => Get.put(HomeController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;
  final RxString fullName = ''.obs;
  final RxString plan = 'free'.obs;
  final RxInt questionsCount = 0.obs;
  final Rx<int?> questionsLimit = Rx<int?>(null);

  final RxList<CoachModel> coaches = <CoachModel>[].obs;
  final RxList<RecentChatModel> recentChats = <RecentChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHome();
  }

  // GET /app/home/
  Future<void> fetchHome() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoint.home);
      if (response != null) {
        final user = response['user'] as Map<String, dynamic>?;
        fullName.value = user?['full_name']?.toString() ?? '';
        plan.value = user?['plan']?.toString() ?? 'free';
        questionsCount.value = (user?['questions_count'] as num?)?.toInt() ?? 0;
        questionsLimit.value = (user?['questions_limit'] as num?)?.toInt();

        if (user?['full_name'] != null) {
          await UserInfo.setFullName(user!['full_name'].toString());
        }

        final coachList = (response['coaches'] as List?) ?? [];
        coaches.value =
            coachList.map((c) => CoachModel.fromJson(c as Map<String, dynamic>)).toList();

        final chatList = (response['recent_chats'] as List?) ?? [];
        recentChats.value = chatList
            .map((c) => RecentChatModel.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    } on HttpException catch (e) {
      print('❌ Home fetch error: ${e.message}');
    } catch (e) {
      print('❌ Home fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => fetchHome();
}