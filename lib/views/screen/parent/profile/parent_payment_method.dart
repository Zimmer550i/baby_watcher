import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentPaymentMethod extends StatelessWidget {
  const ParentPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Payment Method"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Select the payment method you want to use.",
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 400)],
                  color: Color(0xff333333),
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff8C4AEF),
                      Color(0xffB749BB),
                      Color(0xffFB3F81),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    SvgPicture.asset(
                      AppIcons.mastercard,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Cards",
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 400)],
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: "Make Payment",
                onTap: () {
                  Get.toNamed(AppRoutes.parentCardDetails);
                },
              ),
              const SizedBox(
                height: 132,
              ),
            ],
          ),
        ),
      ),
    );
  }
}