import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';
import '../controller/saved_controller.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  static const _gold = Color(0xFFD4A843);

  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    // Warm up the saved list so bookmark icons show the right state.
    SavedController.to;

    // If navigated here with arguments (sessionId/coach), load that session.
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['sessionId'] != null) {
      ChatController.to.openSession(
        args['sessionId'] as String,
        coach: args['coach'],
      );
    }
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final controller = ChatController.to;
    final text = _msgCtrl.text;
    if (text.trim().isEmpty) return;

    // A coach must be selected first (text is kept so nothing is lost).
    if (controller.currentCoach.value == null) {
      Get.snackbar('Select a coach', 'Choose a coach at the top of the chat first.');
      return;
    }

    controller.sendMessage(text);
    _msgCtrl.clear();
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatController.to;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildAppBar(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                final hasCoach = controller.currentCoach.value != null;
                return Center(
                  child: Text(
                    hasCoach
                        ? 'Ask anything to get started.'
                        : 'Select a coach at the top to get started.',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF888888)),
                  ),
                );
              }
              return ListView.builder(
                controller: _scrollCtrl,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: controller.messages.length,
                itemBuilder: (ctx, i) => _buildBubble(controller.messages[i]),
              );
            }),
          ),
          _buildInputBar(context, controller),
        ],
      ),
    );
  }

  // ─── App bar ───────────────────────────────────────────────────────
  Widget _buildAppBar(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.table_rows_outlined, color: const Color(0xFF1A1A1A), size: 26.sp),
          const Spacer(),
          _buildCoachPicker(controller),
          const Spacer(),
          SizedBox(width: 26.w),
        ],
      ),
    );
  }

  // ─── Coach picker (tap the title to choose a coach) ────────────────
  Widget _buildCoachPicker(ChatController controller) {
    final home = HomeController.to;

    return Obx(() {
      final current = controller.currentCoach.value;

      return PopupMenuButton<CoachModel>(
        tooltip: 'Select coach',
        offset: Offset(0, 44.h),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        onSelected: controller.selectCoach,
        itemBuilder: (_) {
          if (home.coaches.isEmpty) {
            return [
              const PopupMenuItem<CoachModel>(
                enabled: false,
                child: Text('Loading coaches...'),
              ),
            ];
          }
          return home.coaches.map((c) {
            final selected = current?.id == c.id;
            return PopupMenuItem<CoachModel>(
              value: c,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.displayName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected ? _gold : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  if (selected) Icon(Icons.check, color: _gold, size: 18.sp),
                ],
              ),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: Text(
                  current != null && current.name.isNotEmpty
                      ? current.name.substring(0, 1)
                      : '?',
                  style: TextStyle(
                    color: const Color(0xFF888888),
                    fontStyle: FontStyle.italic,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              current != null ? current.displayName : 'Select a coach',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: _gold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: _gold, size: 22.sp),
          ],
        ),
      );
    });
  }

  // ─── Input bar ─────────────────────────────────────────────────────
  Widget _buildInputBar(BuildContext context, ChatController controller) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 10.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 90.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        child: Row(
          children: [
            Icon(Icons.add, color: const Color(0xFF888888), size: 22.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Ask NailGPT...',
                  hintStyle: TextStyle(color: const Color(0xFF888888), fontSize: 14.sp),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
              ),
            ),
            Icon(Icons.mic_none, color: const Color(0xFF888888), size: 22.sp),
            SizedBox(width: 8.w),
            Obx(() => controller.isSending.value
                ? SizedBox(
              width: 18.sp,
              height: 18.sp,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
                : GestureDetector(
              onTap: _send,
              child: Icon(Icons.send, color: _gold, size: 22.sp),
            )),
          ],
        ),
      ),
    );
  }

  // ─── Bookmark (save / unsave an assistant message) ─────────────────
  // POST   /app/saved/          { message_id }  -> saved record
  // DELETE /app/saved/{savedId}/                -> unsave
  // SavedController maps message id -> saved id from its loaded list.
  Widget _bookmarkButton(ChatMessageModel msg) {
    final saved = SavedController.to;

    return Obx(() {
      final isSaved = saved.isSaved(msg.id);
      final busy = saved.isBusy(msg.id);

      if (busy) {
        return Padding(
          padding: EdgeInsets.all(4.sp),
          child: SizedBox(
            width: 18.sp,
            height: 18.sp,
            child: const CircularProgressIndicator(strokeWidth: 2, color: _gold),
          ),
        );
      }

      return InkResponse(
        radius: 22.sp,
        onTap: () => saved.toggleByMessage(msg.id),
        child: Padding(
          padding: EdgeInsets.all(4.sp),
          child: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            size: 20.sp,
            color: isSaved ? _gold : Colors.grey.shade600,
          ),
        ),
      );
    });
  }

  // ─── Chat bubble ───────────────────────────────────────────────────
  Widget _buildBubble(ChatMessageModel msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h, left: 48.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.white, size: 16.sp),
              ),
              Flexible(
                child: Text(
                  msg.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h, right: 48.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'NAILGPT 🤖:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                _bookmarkButton(msg),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              msg.content,
              style: TextStyle(color: const Color(0xFF1A1A1A), fontSize: 14.sp, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}