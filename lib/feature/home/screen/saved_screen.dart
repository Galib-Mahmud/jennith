import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            SizedBox(height: 24.h),

            // ── Header ────────────────────────────────────────
            Text(
              'Your library',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Saved',
              style: TextStyle(
                fontSize: 34.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFD4A843),
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            SizedBox(height: 20.h),

            // ── Search bar ────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Saved Items',
                  hintStyle: TextStyle(
                      color: const Color(0xFF888888), fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search,
                      color: const Color(0xFF888888), size: 20.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ── Saved cards ───────────────────────────────────
            _savedCard(
              coach: 'Business Coach',
              coachInitial: 'B',
              time: 'Yesterday',
              title: 'On running a business',
              body:
              '"You\'re running a business, not a charity. Charge what your time and product costs are worth."',
            ),
            _savedCard(
              coach: 'Pricing Coach',
              coachInitial: 'P',
              time: 'Today',
              title: 'Price increase announcement',
              body:
              '"Hi beauties! ✨ To continue providing you with the highest quality products and education, my service menu will be seeing a slight price increase starting [Date]..."',
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _savedCard({
    required String coach,
    required String coachInitial,
    required String time,
    required String title,
    required String body,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card content ──────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coach + time row
                Row(
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A843).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          coachInitial,
                          style: TextStyle(
                            color: const Color(0xFFD4A843),
                            fontStyle: FontStyle.italic,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      coach,
                      style: TextStyle(
                        color: const Color(0xFFD4A843),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text('·',
                        style: TextStyle(
                            color: const Color(0xFF888888), fontSize: 13.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      time,
                      style: TextStyle(
                          color: const Color(0xFF888888), fontSize: 13.sp),
                    ),
                    const Spacer(),
                    Icon(Icons.bookmark,
                        color: const Color(0xFFD4A843), size: 20.sp),
                  ],
                ),
                SizedBox(height: 10.h),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFFD4A843),
                    fontStyle: FontStyle.italic,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                // Body
                Text(
                  body,
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Actions row ───────────────────────────────────
          Divider(height: 1.h, color: const Color(0xFFEEEEEE)),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.copy_outlined,
                    size: 16.sp, color: const Color(0xFF888888)),
                SizedBox(width: 6.w),
                Text('Copy',
                    style: TextStyle(
                        color: const Color(0xFF888888), fontSize: 13.sp)),
                SizedBox(width: 20.w),
                Icon(Icons.share_outlined,
                    size: 16.sp, color: const Color(0xFF888888)),
                SizedBox(width: 6.w),
                Text('Share',
                    style: TextStyle(
                        color: const Color(0xFF888888), fontSize: 13.sp)),
                const Spacer(),
                Text(
                  'Open chat',
                  style: TextStyle(
                    color: const Color(0xFFD4A843),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right,
                    color: const Color(0xFFD4A843), size: 16.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}