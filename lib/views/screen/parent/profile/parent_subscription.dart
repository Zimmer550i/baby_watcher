import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/subscription_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentSubscription extends StatelessWidget {
  const ParentSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Subscribe to Premium"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                SubscriptionWidget(
                  icon: AppIcons.planBasic,
                  title: "Basic Plan",
                  subTitle: "Free",
                  pros: ["Messaging Access"],
                  cons: ["No Video Features"],
                  onTap: () {
                    Get.toNamed(AppRoutes.parentPaymentMethod);
                  },
                ),
                const SizedBox(height: 24),
                SubscriptionWidget(
                  icon: AppIcons.planStandard,
                  title: "Standard Plan",
                  subTitle: "\$X/month",
                  pros: ["Video Access (3 videos per day)", "Messaging Access"],
                  cons: [],
                  coloredButton: true,
                  onTap: () {
                    Get.toNamed(AppRoutes.parentPaymentMethod);
                  },
                ),
                const SizedBox(height: 24),
                SubscriptionWidget(
                  icon: AppIcons.planPremium,
                  title: "Premium Plan",
                  subTitle: "\$X/month",
                  pros: [
                    "Unlimited Video Requests",
                    "Video Storage",
                    "Video Downloads",
                    "Messaging Access",
                  ],
                  cons: [],
                  onTap: () {
                    Get.toNamed(AppRoutes.parentPaymentMethod);
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
