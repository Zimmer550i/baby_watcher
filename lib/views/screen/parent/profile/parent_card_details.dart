import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentCardDetails extends StatefulWidget {
  const ParentCardDetails({super.key});

  @override
  State<ParentCardDetails> createState() => _ParentCardDetailsState();
}

class _ParentCardDetailsState extends State<ParentCardDetails> {
  bool isLoading = false;
  TextEditingController hnController = TextEditingController(
    text: "Esther Howard",
  );
  TextEditingController numController = TextEditingController(
    text: "4874 5246 9874 4528",
  );
  TextEditingController cvvController = TextEditingController(text: "755");
  DateTime expiryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Card Details"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                title: "Card Holder Name",
                controller: hnController,
              ),
              CustomTextField(title: "Card Number", controller: numController),
              CustomTextField(
                title: "Expiry Date",
                controller: TextEditingController(
                  text:
                      "${expiryDate.day}/${expiryDate.month}/${expiryDate.year}",
                ),
                isDisabled: true,
                onTap: () async {
                  DateTime? temp = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  );
                  setState(() {
                    if (temp != null) {
                      expiryDate = temp;
                    }
                  });
                },
              ),
              CustomTextField(title: "CVV", controller: cvvController),
              const SizedBox(),
              CustomButton(
                text: "Confirm Purchase",
                isLoading: isLoading,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  final message =
                      await Get.find<UserController>().subscribeDemo();

                  showSnackBar(message);

                  Get.toNamed(AppRoutes.parentConfirmation);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
