import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController(
    text: "Arlene Flores",
  );
  TextEditingController emailController = TextEditingController(
    text: "ArleneFlores@mail.com",
  );
  TextEditingController phoneController = TextEditingController(
    text: "01825067299",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(isEditing ? "Edit Profile" : "Profile Information"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/user.png",
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                      if (isEditing)
                        Container(
                          height: 96,
                          width: 96,
                          color: Colors.black.withAlpha(102),
                          child: Center(
                            child: SvgPicture.asset(AppIcons.editProfile),
                          ),
                        ),
                    ],
                  ),
                ),
                CustomTextField(
                  title: "Your Name",
                  isDisabled: !isEditing,
                  controller: nameController,
                ),
                if (!isEditing)
                  CustomTextField(
                    title: "Email",
                    isDisabled: !isEditing,
                    controller: emailController,
                  ),
                CustomTextField(
                  title: "Phone Number",
                  isDisabled: !isEditing,
                  controller: phoneController,
                ),
                const SizedBox(height: 0),
                CustomButton(
                  text: isEditing ? "Update Information" : "Edit Information",
                  onTap: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
