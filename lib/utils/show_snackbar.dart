import 'package:baby_watcher/main.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(String message, {bool isError = true}) {
  rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: isError ? AppColors.red : AppColors.indigo,
      content: Text(
        message,
        style: TextStyle(
          fontVariations: [FontVariation("wght", 400)],
          fontSize: 14,
          color: AppColors.indigo[25],
        ),
      ),
    ),
  );
}
