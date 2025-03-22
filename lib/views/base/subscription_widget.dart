import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final List<String> pros;
  final List<String> cons;
  final bool isPurchased;
  final Function()? onTap;
  const SubscriptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.pros = const [],
    this.cons = const [],
    this.isPurchased = false,
    this.onTap,
  });

  SubscriptionWidget copyWith({
    String? icon,
    String? title,
    String? subTitle,
    List<String>? pros,
    List<String>? cons,
    bool? isPurchased,
    Function()? onTap,
  }) {
    return SubscriptionWidget(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      isPurchased: isPurchased ?? this.isPurchased,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPurchased ? Border.all(color: AppColors.indigo) : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              spacing: 16,
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color: AppColors.indigo[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: SvgPicture.asset(icon)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 600)],
                        fontSize: 20,
                        color: AppColors.gray[700],
                      ),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 500)],
                        fontSize: 24,
                        color: AppColors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: isPurchased ? AppColors.indigo : AppColors.indigo[200],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  "Features",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    fontSize: 16,
                    color: AppColors.gray[700],
                  ),
                ),
                ...pros.map((e) {
                  return Row(
                    spacing: 8,
                    children: [
                      SvgPicture.asset(AppIcons.tickCircle),
                      Text(
                        e,
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 16,
                          color: AppColors.gray[600],
                        ),
                      ),
                    ],
                  );
                }),
                ...cons.map((e) {
                  return Row(
                    spacing: 8,
                    children: [
                      SvgPicture.asset(AppIcons.closeCircle),
                      Text(
                        e,
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 16,
                          color: AppColors.gray[600],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: isPurchased ? "Current Plan" : "Choose Plan",
              leading: isPurchased ? AppIcons.tickCircle : null,
              isSecondary: isPurchased,
              onTap: onTap,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
