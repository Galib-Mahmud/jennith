import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/feature/auth/controller/auth_controller.dart';
import 'package:nail_gpt/feature/home/screen/privacy_screen.dart';
import 'package:nail_gpt/feature/home/screen/terms_screen.dart';
import 'package:nail_gpt/routes/approute.dart';

import '../controller/profile_controller.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;

    return SafeArea(
      bottom: false,
      child: Obx(() {
        final profile = controller.profile.value;
        final loading = controller.isLoading.value && profile == null;

        return ListView(
          children: [
            // ── Header ──────────────────────────────────────────
            Container(
              color: const Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4A843),
                  ),
                ),
              ),
            ),

            // ── Avatar ──────────────────────────────────────────
            SizedBox(height: 28.h),
            Center(child: _avatar(profile?.avatarUrl)),

            SizedBox(height: 14.h),
            Center(
              child: loading
                  ? SizedBox(
                height: 22.h,
                width: 22.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(
                profile?.fullName.isNotEmpty == true
                    ? profile!.fullName
                    : 'Your name',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD4A843),
                ),
              ),
            ),
            if (profile != null) ...[
              SizedBox(height: 4.h),
              Center(
                child: Text(
                  _planLabel(profile),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                  ),
                ),
              ),
            ],

            SizedBox(height: 28.h),

            // ── Menu ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account section
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _tile(
                    icon: Icons.person_outline,
                    label: 'Personal info',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PersonalInformationScreen(),
                      ),
                    ),
                  ),
                  if (profile == null || !profile.isLifetime)
                    _tile(
                      icon: Icons.monetization_on_outlined,
                      label: 'Upgrade to Premium',
                      onTap: () => _showUpgrade(context, controller),
                    ),
                  _tile(
                    icon: Icons.archive_outlined,
                    label: 'Archived chats',
                    onTap: () {
                      // TODO: navigate to archived chats screen
                    },
                  ),

                  SizedBox(height: 24.h),

                  // About section
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _tile(
                    icon: Icons.description_outlined,
                    label: 'Terms of Use',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SupportAndLegalScreen(),
                      ),
                    ),
                  ),
                  _tile(
                    icon: Icons.lock_outline,
                    label: 'Privacy Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ── Logout ────────────────────────────────────
                  GestureDetector(
                    onTap: () => _confirmLogout(context, controller),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: const Color(0xFFE53935), size: 22.sp),
                          SizedBox(width: 14.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: const Color(0xFFE53935),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _planLabel(UserProfileModel p) {
    if (p.isLifetime) return 'Lifetime member';
    final limit = p.questionsLimit;
    if (limit != null) {
      return 'Free plan · ${p.questionsCount}/$limit questions used';
    }
    return 'Free plan';
  }

  // ─── Avatar with network image + fallback ───────────────────────────
  Widget _avatar(String? url) {
    return Stack(
      children: [
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4A843), width: 2.5.w),
          ),
          child: ClipOval(
            child: (url != null && url.isNotEmpty)
                ? Image.network(
              url,
              width: 96.w,
              height: 96.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _avatarPlaceholder(),
            )
                : _avatarPlaceholder(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A843),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
            ),
            child: Icon(Icons.star, color: Colors.white, size: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: const Color(0xFFD9C5A0),
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 50.sp, color: Colors.white),
    );
  }

  // ─── Upgrade (stub endpoint) ────────────────────────────────────────
  Future<void> _showUpgrade(
      BuildContext context, ProfileController controller) async {
    final message = await controller.fetchUpgradeInfo();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Upgrade to Premium', style: TextStyle(fontSize: 17.sp)),
        content: Text(
          message ?? 'Payments are coming soon.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ─── Logout confirmation ────────────────────────────────────────────
  // Removes access + refresh token (AuthController.logout -> UserInfo.clearAll)
  // and sends the user to the sign-in screen, clearing the back stack.
  void _confirmLogout(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Log out?', style: TextStyle(fontSize: 17.sp)),
        content: Text(
          'You will need to sign in again to continue.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // close the dialog
              controller.profile.value = null; // next user must not see old data
              await AuthController.to.logout(); // clears tokens + goes to sign-in
            },
            child: const Text(
              'Log out',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.pricing);
      }
      ,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF444444), size: 22.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF444444),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: const Color(0xFFCCCCCC), size: 20.sp),
          ],
        ),
      ),
    );
  }
}