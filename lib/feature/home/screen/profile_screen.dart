import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nail_gpt/feature/home/screen/privacy_screen.dart';
import 'package:nail_gpt/feature/home/screen/terms_screen.dart';
import 'personal_information_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
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
          Center(
            child: Stack(
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFFD4A843), width: 2.5.w),
                  ),
                  child: CircleAvatar(
                    radius: 44.r,
                    backgroundColor: const Color(0xFFD9C5A0),
                    child: Icon(Icons.person, size: 50.sp, color: Colors.white),
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
            ),
          ),

          SizedBox(height: 14.h),
          Center(
            child: Text(
              'Sarah Jenkins',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4A843),
              ),
            ),
          ),

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
                  context: context,
                  icon: Icons.person_outline,
                  label: 'Personal info',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PersonalInformationScreen(),
                    ),
                  ),
                ),
                _tile(
                  context: context,
                  icon: Icons.monetization_on_outlined,
                  label: 'Upgrade to Premium',
                  onTap: () {
                    // TODO: navigate to upgrade screen
                  },
                ),
                _tile(
                  context: context,
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
                  context: context,
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
                  context: context,
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

                // Logout
                GestureDetector(
                  onTap: () {
                    // TODO: handle logout
                  },
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

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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