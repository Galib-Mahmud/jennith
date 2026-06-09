import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _msgCtrl = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: true,
      text: 'How do I scale my nail business to 6 figures?',
    ),
    _ChatMessage(
      isUser: false,
      text:
      'Start by focusing on three things:\n• Premium pricing\n• Consistent content\n• Client retention systems\n\nMost nail techs work harder. Successful nail techs build systems that work for them.',
    ),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => _buildBubble(_messages[i]),
            ),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  // ─── App bar ─────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.table_rows_outlined,
              color: const Color(0xFF1A1A1A), size: 26.sp),
          const Spacer(),
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A843).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                'P',
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
            'Pricing Coach',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD4A843),
            ),
          ),
          const Spacer(),
          SizedBox(width: 26.w),
        ],
      ),
    );
  }

  // ─── Input bar ───────────────────────────────────────────────────────────
  Widget _buildInputBar(BuildContext context) {
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
                decoration: InputDecoration(
                  hintText: 'Ask to NailGPT......',
                  hintStyle: TextStyle(
                      color: const Color(0xFF888888), fontSize: 14.sp),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
              ),
            ),
            Icon(Icons.mic_none, color: const Color(0xFF888888), size: 22.sp),
            SizedBox(width: 8.w),
            Icon(Icons.send, color: const Color(0xFFD4A843), size: 22.sp),
          ],
        ),
      ),
    );
  }

  // ─── Chat bubble ─────────────────────────────────────────────────────────
  Widget _buildBubble(_ChatMessage msg) {
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
                  msg.text,
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

    // AI bubble
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
                  'NAILGPT 👑:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.bookmark_border,
                    size: 18.sp, color: Colors.grey.shade600),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              msg.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  const _ChatMessage({required this.isUser, required this.text});
}