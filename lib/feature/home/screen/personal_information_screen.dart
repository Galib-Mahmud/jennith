import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/profile_controller.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  File? _pickedImage;

  bool _prefilled = false;
  Worker? _profileWorker;

  @override
  void initState() {
    super.initState();
    final controller = ProfileController.to;

    // Prefill immediately if the profile is already loaded…
    final current = controller.profile.value;
    if (current != null) _prefill(current);

    // …otherwise fill in once it arrives (without stomping user edits).
    _profileWorker = ever<UserProfileModel?>(controller.profile, (p) {
      if (p != null && !_prefilled) _prefill(p);
    });
  }

  void _prefill(UserProfileModel p) {
    _nameCtrl.text = p.fullName;
    _emailCtrl.text = p.email;
    _prefilled = true;
  }

  @override
  void dispose() {
    _profileWorker?.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    final ok = await ProfileController.to.updateProfile(
      fullName: _nameCtrl.text,
      avatar: _pickedImage,
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;

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
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Full name'),
                    SizedBox(height: 8.h),
                    _inputField(
                      controller: _nameCtrl,
                      hint: 'Your name',
                    ),
                    SizedBox(height: 16.h),

                    _label('Email'),
                    SizedBox(height: 8.h),
                    _inputField(
                      controller: _emailCtrl,
                      hint: 'you@email.com',
                      keyboardType: TextInputType.emailAddress,
                      enabled: false, // email isn't editable via this endpoint
                    ),
                    SizedBox(height: 16.h),

                    _label('Profile photo'),
                    SizedBox(height: 8.h),
                    _imagePickerField(),
                  ],
                ),
              ),
            ),

            // ── Save button ─────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isSaving.value ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A843),
                    disabledBackgroundColor:
                    const Color(0xFFD4A843).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isSaving.value
                      ? SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    'Save changes',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF444444),
    ),
  );

  // ─── Plain text input ────────────────────────────────────────────────
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2.w),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: TextStyle(
          fontSize: 14.sp,
          color: enabled ? const Color(0xFF1A1A1A) : const Color(0xFF888888),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFAAAAAA)),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }

  // ─── Image picker row ────────────────────────────────────────────────
  Widget _imagePickerField() {
    final fileName =
    _pickedImage != null ? _pickedImage!.path.split('/').last : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2.w),
      ),
      child: Row(
        children: [
          if (_pickedImage != null) ...[
            Padding(
              padding: EdgeInsets.all(6.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  _pickedImage!,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Text(
                fileName ?? 'Choose image',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: fileName != null
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFAAAAAA),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
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