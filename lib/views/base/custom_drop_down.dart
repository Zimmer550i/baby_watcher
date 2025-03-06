import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropDown extends StatefulWidget {
  final String? title;
  final String? initialPick;
  final String? hintText;
  final List<String> options;
  final double radius;
  final void Function(String)? onChanged;
  const CustomDropDown({
    super.key,
    this.title,
    this.initialPick,
    this.hintText,
    required this.options,
    this.onChanged,
    this.radius = 24,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? currentVal;
  bool isExpanded = false;
  Duration defaultDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    currentVal = widget.initialPick;
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

        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(width: 0.5, color: AppColors.indigo.shade400),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      currentVal == null
                          ? Text(
                            widget.hintText ?? "Select One",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 500)],
                              color: AppColors.gray[400],
                              fontSize: 14,
                            ),
                          )
                          : Text(
                            currentVal!,
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 500)],
                              color: AppColors.gray.shade600,
                              height: 1,
                            ),
                          ),
                      const Spacer(),
                      AnimatedRotation(
                        duration: defaultDuration,
                        turns: isExpanded ? 0.5 : 1,
                        child: SvgPicture.asset(AppIcons.arrowDown),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: defaultDuration,
                  child:
                      isExpanded
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.options.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = false;
                                      currentVal = e;
                                      widget.onChanged ?? (e);
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: AppColors.indigo[300]!,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          fontVariations: [
                                            FontVariation("wght", 500),
                                          ],
                                          color: AppColors.gray[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          )
                          : SizedBox(height: 0, width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
