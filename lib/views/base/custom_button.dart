import 'package:baby_watcher/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool isSecondary;
  final bool isDisabled;
  final double? height;
  final double? width;
  final String? leading;
  final double padding;
  final double radius;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.leading,
    this.padding = 40,
    this.radius = 99,
    this.isSecondary = false,
    this.isDisabled = false,
    this.height = 48,
    this.width = double.infinity,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.height!),
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        decoration: BoxDecoration(
          color:
              widget.isSecondary
                  ? AppColors.indigo[25]
                  : widget.isDisabled
                  ? AppColors.indigo.shade300
                  : AppColors.indigo.shade500,
          borderRadius: BorderRadius.circular(widget.radius),
          border:
              widget.isSecondary ? Border.all(color: AppColors.indigo) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (widget.leading != null)
              SvgPicture.asset(
                widget.leading!,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.indigo[25]!,
                  BlendMode.srcIn,
                ),
              ),
            Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color:
                    widget.isSecondary
                        ? AppColors.indigo
                        : AppColors.indigo[25],
                fontVariations: [FontVariation('wght', 600)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
