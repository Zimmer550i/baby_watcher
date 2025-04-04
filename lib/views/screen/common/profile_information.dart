import 'dart:io';

import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:baby_watcher/views/base/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final user = Get.find<UserController>();
  File? _pickedImage;
  bool isEditing = false;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDefaults();
  }

  void loadDefaults() {
    nameController.text = user.userName;
    emailController.text = user.userEmail;
    phoneController.text = user.userPhone;
    _pickedImage = null;
  }

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
                GestureDetector(
                  onTap: () async {
                    if (!isEditing) {
                      return;
                    }
                    ImagePicker imagePicker = ImagePicker();
                    final xImage = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (xImage != null) {
                      setState(() {
                        _pickedImage = File(xImage.path);
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child:
                            _pickedImage != null
                                ? Image.file(
                                  _pickedImage!,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                )
                                : ProfilePicture(
                                  image: user.image,
                                  size: 96,
                                ),
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: -8,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppIcons.editProfile,
                                height: 16,
                                width: 16,
                              ),
                            ),
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
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: isEditing ? "Cancel" : "Edit Information",
                        isSecondary: isEditing,
                        onTap: () {
                          if (isEditing) {
                            loadDefaults();
                            setState(() {
                              isEditing = false;
                            });
                          } else {
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                      ),
                    ),
                    if (isEditing) const SizedBox(width: 16),
                    if (isEditing)
                      Expanded(
                        child: CustomButton(
                          text: "Update",
                          isLoading: isLoading,
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Map<String, dynamic> data = {};
                            if (_pickedImage == null) {
                              data = {
                                "name": nameController.text.trim(),
                                "phone": phoneController.text.trim(),
                              };
                            } else {
                              data = {
                                "name": nameController.text.trim(),
                                "phone": phoneController.text.trim(),
                                "image": _pickedImage,
                              };
                            }
                            final response = await user.updateInfo(data);

                            if (response == "Success") {
                              await user.getInfo();
                              Get.back();
                              showSnackBar(
                                "User Information Updated",
                                isError: false,
                              );
                            } else {
                              showSnackBar(response);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
