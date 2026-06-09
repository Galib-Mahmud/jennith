import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _selectedImageName;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(vertical: 22.h),
              child: Text(
                'Personal Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A843),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Divider(height: 1.h, color: const Color(0xFFE0E0E0)),

            // ── Form ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    _inputField(
                      controller: _nameCtrl,
                      hint: "e.g. Campbell's",
                    ),
                    SizedBox(height: 16.h),

                    // Email field
                    _inputField(
                      controller: _emailCtrl,
                      hint: 'Kurtcobain@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),

                    // Image picker field
                    _imagePickerField(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Plain text input ────────────────────────────────────────────────────
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2.w),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFFAAAAAA),
          ),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }

  // ─── Image picker row ────────────────────────────────────────────────────
  Widget _imagePickerField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2.w),
      ),
      child: Row(
        children: [
          // Label / file name
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Text(
                _selectedImageName ?? 'Choose image',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _selectedImageName != null
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFAAAAAA),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Choose button
          GestureDetector(
            onTap: () {
              // TODO: integrate image_picker
              setState(() {
                _selectedImageName = 'profile_photo.jpg';
              });
            },
            child: Container(
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.symmetric(
                  horizontal: 28.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A843),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Choose',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}