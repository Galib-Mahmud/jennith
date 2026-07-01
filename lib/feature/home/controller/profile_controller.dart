// lib/feature/profile/controller/profile_controller.dart

import 'dart:io';

import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../home/controller/home_controller.dart';

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? avatarUrl;
  final String plan; // 'free' | 'lifetime'
  final String subscriptionStatus; // 'active' | 'refunded'
  final int questionsCount;
  final int? questionsLimit; // null for lifetime
  final DateTime? dateJoined;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.avatarUrl,
    required this.plan,
    required this.subscriptionStatus,
    required this.questionsCount,
    required this.questionsLimit,
    required this.dateJoined,
  });

  bool get isLifetime => plan == 'lifetime';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id']?.toString() ?? '',
        fullName: json['full_name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        mobileNumber: json['mobile_number']?.toString() ?? '',
        avatarUrl: json['avatar_url']?.toString(),
        plan: json['plan']?.toString() ?? 'free',
        subscriptionStatus:
        json['subscription_status']?.toString() ?? 'active',
        questionsCount: (json['questions_count'] as num?)?.toInt() ?? 0,
        questionsLimit: (json['questions_limit'] as num?)?.toInt(),
        dateJoined: DateTime.tryParse(json['date_joined']?.toString() ?? ''),
      );
}

class ProfileController extends GetxController {
  static ProfileController get to =>
      Get.put(ProfileController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs; // loading profile
  final RxBool isSaving = false.obs; // updating name/avatar
  final RxBool isChangingPassword = false.obs;

  final Rx<UserProfileModel?> profile = Rx<UserProfileModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ─────────────────────────────────────────────────────────────────
  // GET /app/profile/
  // ─────────────────────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoint.profile);
      if (response is Map<String, dynamic>) {
        profile.value = UserProfileModel.fromJson(response);
        await UserInfo.setFullName(profile.value!.fullName);
      }
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Could not load profile.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // PATCH /app/profile/   (multipart: full_name, avatar)
  // Both fields optional — send only what changed.
  // ─────────────────────────────────────────────────────────────────
  Future<bool> updateProfile({String? fullName, File? avatar}) async {
    final nameChanged = fullName != null && fullName.trim().isNotEmpty;
    if (!nameChanged && avatar == null) {
      Get.snackbar('Nothing to update', 'Change your name or pick a photo first.');
      return false;
    }

    isSaving.value = true;
    try {
      final fields = <String, String>{};
      if (nameChanged) fields['full_name'] = fullName.trim();

      final files = <String, File>{};
      if (avatar != null) files['avatar'] = avatar; // ⚠️ see note below

      final response = await _apiClient.multipart(
        ApiEndpoint.profile,
        method: 'PATCH',
        fields: fields,
        files: files.isEmpty ? null : files,
      );

      if (response is Map<String, dynamic>) {
        profile.value = UserProfileModel.fromJson(response);
        await UserInfo.setFullName(profile.value!.fullName);
        // Keep the home-screen greeting in sync without recreating the
        // controller (avoids re-triggering its onInit fetch).
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fullName.value = profile.value!.fullName;
        }
      }
      Get.snackbar('Saved', 'Your profile has been updated.');
      return true;
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Could not update profile.');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // POST /app/profile/change-password/
  // ─────────────────────────────────────────────────────────────────
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    if (newPassword != confirmNewPassword) {
      Get.snackbar('Error', 'New passwords do not match.');
      return false;
    }
    isChangingPassword.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.changePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        },
      );
      Get.snackbar('Success', 'Password changed successfully.');
      return true;
    } on HttpException catch (e) {
      // 400 = wrong current password / weak or mismatched new password.
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Could not change password.');
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // GET /app/profile/upgrade/   (stub — returns a placeholder message)
  // ─────────────────────────────────────────────────────────────────
  Future<String?> fetchUpgradeInfo() async {
    try {
      final response = await _apiClient.get(ApiEndpoint.upgradeInfo);
      if (response is Map<String, dynamic>) {
        return response['detail']?.toString() ?? response.toString();
      }
      return response?.toString();
    } on HttpException catch (e) {
      Get.snackbar('Error', e.message);
      return null;
    } catch (e) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Logout — clears local session. Caller handles navigation.
  // ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await UserInfo.clearAll();
    profile.value = null;
  }

  Future<void> refresh() => fetchProfile();
}