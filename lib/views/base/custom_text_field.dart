import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? leading;
  final String? trailing;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isOtp;
  const CustomTextField({
    super.key,
    this.title,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isOtp = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = false;
  bool isFocused = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isObscured = widget.isPassword;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              fontVariations: [FontVariation("wght", 600)],
              fontSize: 16,
              color: AppColors.gray[600],
            ),
          ),
        Container(
          height: 48,
          width: widget.isOtp ? 48 : double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isFocused ? AppColors.indigo[50] : Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: isFocused ? 1 : 0.5,
              color: AppColors.indigo.shade400,
            ),
          ),
          child: Row(
            spacing: 12,
            children: [
              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  child: SvgPicture.asset(
                    AppIcons.lock,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.gray[400]!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              if (widget.leading != null)
                SvgPicture.asset(
                  widget.leading!,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.gray[400]!,
                    BlendMode.srcIn,
                  ),
                ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: widget.controller,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontVariations: [FontVariation("wght", 500)],
                      color: AppColors.gray[400],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null)
                SvgPicture.asset(
                  widget.trailing!,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.gray[400]!,
                    BlendMode.srcIn,
                  ),
                ),
              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  child: SvgPicture.asset(
                    AppIcons.eyeOff,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.gray[400]!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
