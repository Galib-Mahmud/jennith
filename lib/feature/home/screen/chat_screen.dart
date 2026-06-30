import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
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
    final text = _msgCtrl.text;
    if (text.trim().isEmpty) return;
    ChatController.to.sendMessage(text);
    _msgCtrl.clear();
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
                return Center(
                  child: Text(
                    'Ask anything to get started.',
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
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A843).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Obx(() => Text(
                controller.currentCoach.value?.name.substring(0, 1) ?? 'P',
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontStyle: FontStyle.italic,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => Text(
            controller.currentCoach.value != null
                ? '${controller.currentCoach.value!.name} Coach'
                : 'NailGPT',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD4A843),
            ),
          )),
          const Spacer(),
          SizedBox(width: 26.w),
        ],
      ),
    );
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
                  hintText: 'Ask to NailGPT......',
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
              child: Icon(Icons.send, color: const Color(0xFFD4A843), size: 22.sp),
            )),
          ],
        ),
      ),
    );
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
            color: const Color(0xFFD4A843),
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
                Icon(Icons.bookmark_border, size: 18.sp, color: Colors.grey.shade600),
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