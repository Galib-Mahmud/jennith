import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/core/endpoint/api_endpoint.dart';

import '../controller/saved_controller.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(local.year, local.month, local.day);
    final diff = today.difference(that).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return '${local.day}/${local.month}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = SavedController.to;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                onChanged: (v) => controller.query.value = v,
                decoration: InputDecoration(
                  hintText: 'Search Saved Items',
                  hintStyle:
                  TextStyle(color: const Color(0xFF888888), fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search,
                      color: const Color(0xFF888888), size: 20.sp),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ── List ──────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = controller.filtered;
                if (list.isEmpty) {
                  return _emptyState(controller.query.value.isNotEmpty);
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchSaved,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 100.h),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) => _savedCard(context, list[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(bool isSearching) {
    return ListView(
      children: [
        SizedBox(height: 120.h),
        Icon(Icons.bookmark_border,
            size: 56.sp, color: const Color(0xFFCCCCCC)),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            isSearching ? 'No matches found.' : 'Nothing saved yet.',
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF888888)),
          ),
        ),
        if (!isSearching) ...[
          SizedBox(height: 6.h),
          Center(
            child: Text(
              'Tap the bookmark on any answer to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFFAAAAAA)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _savedCard(BuildContext context, SavedMessageModel item) {
    final coachName = item.coach?.name ?? 'Coach';
    final coachInitial =
    coachName.isNotEmpty ? coachName.substring(0, 1).toUpperCase() : 'C';

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
                      '$coachName Coach',
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
                      _relativeTime(item.createdAt),
                      style: TextStyle(
                          color: const Color(0xFF888888), fontSize: 13.sp),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => controller.unsave(item.id),
                      child: Icon(Icons.bookmark,
                          color: const Color(0xFFD4A843), size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Title (session title)
                Text(
                  item.sessionTitle,
                  style: TextStyle(
                    color: const Color(0xFFD4A843),
                    fontStyle: FontStyle.italic,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                // Body (message content)
                Text(
                  item.content,
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: item.content));
                    Get.snackbar('Copied', 'Message copied to clipboard.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.copy_outlined,
                          size: 16.sp, color: const Color(0xFF888888)),
                      SizedBox(width: 6.w),
                      Text('Copy',
                          style: TextStyle(
                              color: const Color(0xFF888888), fontSize: 13.sp)),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  // Swap in share_plus's Share.share(item.content) if you add
                  // the package; copying keeps this dependency-free for now.
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: item.content));
                    Get.snackbar('Copied', 'Message copied — paste to share.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined,
                          size: 16.sp, color: const Color(0xFF888888)),
                      SizedBox(width: 6.w),
                      Text('Share',
                          style: TextStyle(
                              color: const Color(0xFF888888), fontSize: 13.sp)),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _openChat(item),
                  child: Row(
                    children: [
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
          ),
        ],
      ),
    );
  }

  SavedController get controller => SavedController.to;

  void _openChat(SavedMessageModel item) {
    if (item.sessionId.isEmpty) return;
    // Mirrors HomeScreen's navigation into the chat screen.
    Get.toNamed(ApiEndpoint.chats, arguments: {
      'sessionId': item.sessionId,
      'coach': item.coach,
    });
  }
}