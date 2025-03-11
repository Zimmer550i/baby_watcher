import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';

class ParentAddContact extends StatelessWidget {
  const ParentAddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add Emergency Contact"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomTextField(leading: AppIcons.person, hintText: "Enter Name"),
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.phone,
              hintText: "Emergency Contact",
            ),
            const SizedBox(height: 24),
            CustomButton(text: "Add", width: null, padding: 65),
          ],
        ),
      ),
    );
  }
}
