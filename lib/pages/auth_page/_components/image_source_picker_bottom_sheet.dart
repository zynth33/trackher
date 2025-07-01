import 'package:flutter/material.dart';

import 'bottom_sheet_button.dart';

class ImageSourcePickerBottomSheet extends StatelessWidget {
  final VoidCallback pickImageFromGallery;
  final VoidCallback pickImageFromCamera;
  final VoidCallback pickAvatar;
  const ImageSourcePickerBottomSheet({super.key, required this.pickImageFromGallery, required this.pickImageFromCamera, required this.pickAvatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetButton(
            icon: Icons.photo_library,
            label: 'Select from Gallery',
            onPressed: pickImageFromGallery,
          ),
          BottomSheetButton(
            icon: Icons.camera_alt,
            label: 'Take Photo with Camera',
            onPressed: pickImageFromCamera,
          ),
          BottomSheetButton(
            icon: Icons.person,
            label: 'Choose Avatar',
            onPressed: pickAvatar,
          ),
        ],
      ),
    );
  }
}
