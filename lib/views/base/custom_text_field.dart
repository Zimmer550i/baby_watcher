import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? errorText;
  final String? leading;
  final String? trailing;
  final bool isDisabled;
  final double radius;
  final TextEditingController? controller;
  final bool isPassword;
  final void Function()? onTap;
  const CustomTextField({
    super.key,
    this.title,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isDisabled = false,
    this.radius = 50,
    this.controller,
    this.onTap,
    this.errorText,
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
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title!,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 600)],
                fontSize: 16,
                color: AppColors.gray[600],
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              if (!widget.isDisabled) {
                focusNode.requestFocus();
              }
            }
          },
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isFocused ? AppColors.indigo[50] : Colors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                width: isFocused ? 1 : 0.5,
                color:
                    widget.errorText != null
                        ? AppColors.red
                        : AppColors.indigo.shade400,
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
                        isFocused ? AppColors.indigo : AppColors.gray[400]!,
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
                      isFocused ? AppColors.indigo : AppColors.gray[400]!,
                      BlendMode.srcIn,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: widget.controller,
                    obscureText: isObscured,
                    enabled: !widget.isDisabled && widget.onTap == null,
                    onTapOutside: (event) {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 500)],
                      color: AppColors.gray.shade600,
                      height: 1,
                    ),
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
                      isFocused ? AppColors.indigo : AppColors.gray[400]!,
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
                      isObscured ? AppIcons.eye : AppIcons.eyeOff,
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        isFocused ? AppColors.indigo : AppColors.gray[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          ),
      ],
    );
  }
}
