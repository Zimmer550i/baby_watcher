import 'package:baby_watcher/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool isSecondary;
  final bool isDisabled;
  final double? height;
  final double? width;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isSecondary = false,
    this.isDisabled = false,
    this.height = 50,
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
        decoration: BoxDecoration(
          color:
              widget.isSecondary
                  ? AppColors.indigo[25]
                  : widget.isDisabled
                  ? AppColors.indigo.shade300
                  : AppColors.indigo.shade500,
          borderRadius: BorderRadius.circular(widget.height!),
          border: widget.isSecondary ? Border.all(color: AppColors.indigo) : null,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: widget.isSecondary ? AppColors.indigo : AppColors.indigo[25],
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
        ),
      ),
    );
  }
}
