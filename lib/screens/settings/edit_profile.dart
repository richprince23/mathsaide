import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/constants/utils.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/select_control1.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:resize/resize.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  String _selectedAge = "12";
  final _schoolController = TextEditingController();
  String? _selectedGrade = "Grade 12";
  final _formKey = GlobalKey<FormState>();
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    auth.userChanges().listen((user) {
      setState(() {
        imgUrl = user?.photoURL ?? "https://picsum.photos/200";
        _fullNameController.text = auth.currentUser!.displayName ?? "";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _schoolController.dispose();
    selectedMedia = null;
    croppedMedia = null;
  }

  initUser() async {
    await Auth.getUserDetails().then((value) {
      setState(() {
        _schoolController.text = value?.data()?["school"] ?? "";
        _selectedAge = value?.data()?["age"] ?? "";
        _selectedGrade = value?.data()?["classLevel"] ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          padding: pa2,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 15.vw,
                        backgroundColor: priCol,
                        child: croppedMedia != null
                            ? ClipOval(
                                child: Image.file(
                                  File(croppedMedia!.path),
                                  width: 28.vw,
                                  height: 28.vw,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50.r,
                                backgroundImage: CachedNetworkImageProvider(
                                  imgUrl,
                                  errorListener: () => const Icon(Icons.person),
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: 0,
                        child: IconButton.filledTonal(
                          // color: priCol,
                          onPressed: () async {
                            await uploadImage().then((value) async =>
                                await cropImage()
                                    .then((value) => setState(() {})));
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                InputControl(
                  hintText: "Fullname",
                  leading: const Icon(Icons.person),
                  controller: _fullNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your fullname";
                    }
                    return null;
                  },
                ),
                SelectControl(
                  initialValue: _selectedAge,
                  onChanged: (age) {
                    setState(() {
                      _selectedAge = age!;
                    });
                  },
                  hintText: "Age",
                  leading: const Icon(Icons.onetwothree),
                  items: ageRange
                      .map(
                        (age) => DropdownMenuItem<String>(
                          alignment: Alignment.centerLeft,
                          value: age,
                          child: Text(age),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your age";
                    }
                    return null;
                  },
                ),
                InputControl(
                  hintText: "School",
                  controller: _schoolController,
                  leading: const Icon(Icons.school),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your school";
                    }
                    return null;
                  },
                ),
                SelectControl(
                  initialValue: _selectedGrade,
                  onChanged: (grade) {
                    setState(() {
                      _selectedGrade = grade!;
                    });
                  },
                  hintText: "Grade (Class)",
                  leading: const Icon(Icons.people),
                  items: classLevel
                      .map(
                        (grade) => DropdownMenuItem<String>(
                          alignment: Alignment.centerLeft,
                          value: grade,
                          child: Text(grade),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your grade";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.w,
                ),
                SizedBox(
                  width: 100.vw,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoader(context);
                        await Auth.updateUser(
                          fullName: _fullNameController.text,
                          age: _selectedAge,
                          school: _schoolController.text,
                          classLevel: _selectedGrade!,
                          imgPath: croppedMedia?.path ?? "",
                        ).then((value) => {
                              Navigator.pop(context),
                              CustomSnackBar.show(
                                context,
                                message: "Profile updated successfully",
                              ),
                            });
                      }
                    },
                    child: const Text("Update Profile"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Crops a selected image file
  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: priCol,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          croppedMedia = croppedFile;
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
    }
  }

  /// clears selected/cropped image from memory
  void clear() {
    selectedMedia = null;
    croppedMedia = null;
  }
}
