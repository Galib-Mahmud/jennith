import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/feature/auth/controller/auth_controller.dart';
import 'package:nail_gpt/routes/approute.dart';

import '../controller/profile_controller.dart';
import 'personal_information_screen.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

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
            // ── Header ─────────────────────────────────────────
            Container(
              color: const Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD4A843),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // ── Avatar & Name ───────────────────────────────────
            SizedBox(height: 20.h),
            Center(child: _avatar(profile?.avatarUrl)),

            SizedBox(height: 16.h),
            Center(
              child: loading
                  ? SizedBox(
                height: 22.h, width: 22.h,
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
              SizedBox(height: 6.h),
              Center(
                child: Text(
                  _planLabel(profile),
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF888888)),
                ),
              ),
            ],

            SizedBox(height: 32.h),

            // ── Menu Items ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Account'),
                  SizedBox(height: 8.h),

                  _tile(
                    icon: Icons.person_outline,
                    label: 'Personal info',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PersonalInformationScreen()),
                    ),
                  ),

                  if (profile == null || !profile.isLifetime)
                    _tile(
                      icon: Icons.monetization_on_outlined,
                      label: 'Upgrade to Premium',
                      onTap: () => Get.toNamed(AppRoutes.pricing), // ✅ Only this goes to pricing
                    ),

                  _tile(
                    icon: Icons.archive_outlined,
                    label: 'Archived chats',
                    onTap: () {
                      // TODO: Navigate to archived chats
                    },
                  ),

                  SizedBox(height: 28.h),
                  _sectionTitle('About'),
                  SizedBox(height: 8.h),

                  _tile(
                    icon: Icons.description_outlined,
                    label: 'Terms of Use',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SupportAndLegalScreen()),
                    ),
                  ),

                  _tile(
                    icon: Icons.lock_outline,
                    label: 'Privacy Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // ── Logout ────────────────────────────────────
                  GestureDetector(
                    onTap: () => _confirmLogout(context, controller),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: const Color(0xFFE53935), size: 22.sp),
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
                  SizedBox(height: 120.h), // Space for bottom nav
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
  );

  String _planLabel(UserProfileModel p) {
    if (p.isLifetime) return 'Lifetime member';
    final limit = p.questionsLimit;
    if (limit != null) return 'Free plan · ${p.questionsCount}/$limit questions used';
    return 'Free plan';
  }

  Widget _avatar(String? url) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4A843), width: 3.w),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: ClipOval(
            child: (url != null && url.isNotEmpty)
                ? Image.network(url, width: 100.w, height: 100.w, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _avatarPlaceholder())
                : _avatarPlaceholder(),
          ),
        ),
        // Star Badge
        Positioned(
          bottom: -2.w,
          right: -2.w,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A843),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5.w),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
            ),
            child: Icon(Icons.star, color: Colors.white, size: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() => Container(
    color: const Color(0xFFD9C5A0),
    alignment: Alignment.center,
    child: Icon(Icons.person, size: 50.sp, color: Colors.white),
  );

  // ✅ FIXED: Now correctly uses the passed onTap callback
  Widget _tile({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap, // ✅ This was previously hardcoded to AppRoutes.pricing
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF444444), size: 22.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 15.sp, color: const Color(0xFF444444), fontWeight: FontWeight.w400)),
            ),
            Icon(Icons.chevron_right, color: const Color(0xFFCCCCCC), size: 20.sp),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Log out?', style: TextStyle(fontSize: 17.sp)),
        content: Text('You will need to sign in again to continue.', style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthController.to.logout();
              Get.offAllNamed(AppRoutes.signIn); // ✅ Ensure you have a signIn route
            },
            child: const Text('Log out', style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
  }
}