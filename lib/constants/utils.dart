import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

XFile? selectedMedia;
CroppedFile? croppedMedia;

/// Crops a selected image file
Future<void> cropImage() async {
  if (selectedMedia != null) {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedMedia!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      croppedMedia = croppedFile;
    }
  }
}


Future<void> uploadImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    selectedMedia = pickedFile;
  }
}

/// clears selected/cropped image from memory
void clear() {
  selectedMedia = null;
  croppedMedia = null;
}

/// Convert a [timestamp] into a Date and Time format. eg. May 19, 2023 at 12:53 pm
String convertDateTimeString(String timestamp) {
  final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
  String formattedDate = DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
  return formattedDate;
}
