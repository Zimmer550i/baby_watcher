import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/subscription_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentSubscription extends StatefulWidget {
  const ParentSubscription({super.key});

  @override
  State<ParentSubscription> createState() => _ParentSubscriptionState();
}

class _ParentSubscriptionState extends State<ParentSubscription> {
  final user = Get.find<UserController>();
  List<SubscriptionWidget> data = [
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
    SubscriptionWidget(
      icon: AppIcons.planStandard,
      title: "Standard Plan",
      subTitle: "\$X/month",
      pros: ["Video Access (3 videos per day)", "Messaging Access"],
      cons: [],
      onTap: () {
        Get.toNamed(AppRoutes.parentPaymentMethod);
      },
    ),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Subscribe to Premium"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.only(top: 24),
            child: Column(
              spacing: 24,
              children: [
                if (user.packageName != null)
                  data
                      .firstWhere((val) => val.title == user.packageName)
                      .copyWith(isPurchased: true),
                ...data.where((val) => val.title != user.packageName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
