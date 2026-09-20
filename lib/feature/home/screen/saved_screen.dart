import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/controller/chat_controller.dart';
import '../controller/app_navigation.dart';
import '../controller/saved_controller.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  static const _gold = Color(0xFFD4A843);
  static const _grey = Color(0xFF888888);

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
                color: _grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Saved',
              style: TextStyle(
                fontSize: 34.sp,
                fontStyle: FontStyle.italic,
                color: _gold,
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
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search Saved Items',
                  hintStyle: TextStyle(color: _grey, fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search, color: _grey, size: 20.sp),
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

                return RefreshIndicator(
                  color: _gold,
                  onRefresh: () => controller.fetchSaved(),
                  child: list.isEmpty
                      ? _emptyState(
                    controller: controller,
                    isSearching: controller.query.value.trim().isNotEmpty,
                  )
                      : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(bottom: 100.h),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) => _savedCard(
                      key: ValueKey(list[i].id),
                      controller: controller,
                      item: list[i],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty / error state (inside a ListView so pull-to-refresh works) ──
  Widget _emptyState({
    required SavedController controller,
    required bool isSearching,
  }) {
    final failed = controller.hasError.value && controller.items.isEmpty;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 100.h),
        Icon(
          failed ? Icons.cloud_off_outlined : Icons.bookmark_border,
          size: 56.sp,
          color: const Color(0xFFCCCCCC),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            failed
                ? 'Could not load your saved items.'
                : (isSearching ? 'No matches found.' : 'Nothing saved yet.'),
            style: TextStyle(fontSize: 15.sp, color: _grey),
          ),
        ),
        SizedBox(height: 6.h),
        if (failed)
          Center(
            child: TextButton(
              onPressed: () => controller.fetchSaved(),
              child: Text(
                'Try again',
                style: TextStyle(
                  color: _gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else if (!isSearching)
          Center(
            child: Text(
              'Tap the bookmark on any answer to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFFAAAAAA)),
            ),
          ),
      ],
    );
  }

  // ─── Saved card ────────────────────────────────────────────────────
  Widget _savedCard({
    required Key key,
    required SavedController controller,
    required SavedMessageModel item,
  }) {
    final coachName = item.coach?.displayName ?? 'Coach';
    final coachInitial = (item.coach?.name.isNotEmpty ?? false)
        ? item.coach!.name.substring(0, 1).toUpperCase()
        : 'C';

    return Container(
      key: key,
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
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 10.w, 12.h),
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
                        color: _gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          coachInitial,
                          style: TextStyle(
                            color: _gold,
                            fontStyle: FontStyle.italic,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        coachName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _gold,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text('·', style: TextStyle(color: _grey, fontSize: 13.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      _relativeTime(item.createdAt),
                      style: TextStyle(color: _grey, fontSize: 13.sp),
                    ),
                    const Spacer(),
                    // Unsave (bigger tap target than the icon itself)
                    Obx(() {
                      final busy = controller.isBusy(item.messageId);
                      return InkResponse(
                        radius: 22.sp,
                        onTap: busy ? null : () => controller.unsave(item.id),
                        child: Padding(
                          padding: EdgeInsets.all(6.sp),
                          child: busy
                              ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _gold,
                            ),
                          )
                              : Icon(Icons.bookmark, color: _gold, size: 20.sp),
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 10.h),
                // Title (session title)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Text(
                    item.sessionTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _gold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Body (message content)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Text(
                    item.content,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF1A1A1A),
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
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
                _action(
                  icon: Icons.copy_outlined,
                  label: 'Copy',
                  onTap: () => _copy(item.content, 'Message copied to clipboard.'),
                ),
                SizedBox(width: 20.w),
                // Copies for now. To use the system share sheet, add the
                // share_plus package and call its share method with item.content.
                _action(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () => _copy(item.content, 'Message copied. Paste it to share.'),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openChat(item),
                  child: Row(
                    children: [
                      Text(
                        'Open chat',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.chevron_right, color: _gold, size: 16.sp),
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

  Widget _action({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: _grey),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(color: _grey, fontSize: 13.sp)),
        ],
      ),
    );
  }

  void _copy(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    Get.closeAllSnackbars();
    Get.snackbar('Copied', message, snackPosition: SnackPosition.BOTTOM);
  }

  // Loads that session into the chat screen, then switches to it.
  void _openChat(SavedMessageModel item) {
    if (item.sessionId.isEmpty) return;
    ChatController.to.openSession(item.sessionId, coach: item.coach);
    AppNavigator.openChatTab();
  }
}