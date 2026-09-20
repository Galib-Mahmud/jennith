import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/app_navigation.dart';
import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';

// ✅ Moved outside the class to avoid scoping/compilation errors
Color _parseHexColor(String hex) {
  try {
    final cleaned = hex.replaceFirst('#', '').trim();
    return Color(int.parse('FF$cleaned', radix: 16));
  } catch (_) {
    return const Color(0xFFD4A843); // Fallback gold color
  }
}

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;
    final chatCtrl = ChatController.to;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chat History',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF1A1A1A)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.recentChats.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.recentChats.isEmpty) {
          return Center(
            child: Text(
              'No chat history yet.',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF888888)),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          itemCount: controller.recentChats.length,
          itemBuilder: (ctx, i) {
            final chat = controller.recentChats[i];
            return _HistoryItem(
              chat: chat,
              onTap: () {
                chatCtrl.selectChat(chat.id, chat.coach);
                AppNavigator.openChatTab();
                Get.back();
              },
            );
          },
        );
      }),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final RecentChatModel chat;
  final VoidCallback onTap;

  const _HistoryItem({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ✅ Now uses the top-level function without errors
    final accentColor = _parseHexColor(chat.coach.accentColor);
    final initial = chat.coach.name.isNotEmpty
        ? chat.coach.name[0].toUpperCase()
        : '?';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4A843),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    chat.lastMessage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18.sp,
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}