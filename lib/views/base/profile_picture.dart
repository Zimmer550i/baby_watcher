import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.image, this.size = 140, this.showLoading = true});

  final double size;
  final String? image;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child:
          image != null
              ? Image.network(
                image!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Center(child:  showLoading ? CircularProgressIndicator() : Container(color: Colors.grey[200],)),
                    );
                  }
                },
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
              : Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(size * 0.17),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.indigo[50],
                ),
                child: SvgPicture.asset(
                  AppIcons.profile,
                  colorFilter: ColorFilter.mode(
                    AppColors.indigo,
                    BlendMode.srcIn,
                  ),
                ),
              ),
    );
  }
}
