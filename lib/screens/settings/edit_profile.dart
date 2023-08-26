import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/select_control1.dart';
import 'package:resize/resize.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: pa2,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 15.vw,
                    backgroundColor: priCol,
                    child: CircleAvatar(
                      radius: 14.vw,
                      backgroundImage: CachedNetworkImageProvider(
                        auth.currentUser!.photoURL ??
                            "https://picsum.photos/200",
                        errorListener: () => const Icon(Icons.person),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: 0,
                    child: IconButton.filledTonal(
                      // color: priCol,
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            const InputControl(
              hintText: "Fullname",
              leading: Icon(Icons.person),
            ),
            SelectControl(
              onChanged: (age) {},
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
            ),
            InputControl(
              hintText: "School",
            ),
            SelectControl(
              onChanged: (grade) {},
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
            ),
            SizedBox(
              height: 20.w,
            ),
            SizedBox(
              width: 100.vw,
              child: ElevatedButton(
                  onPressed: () {}, child: const Text("Update Profile")),
            )
          ],
        ),
      ),
    );
  }
}
