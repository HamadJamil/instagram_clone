// utils/toast_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastUtils {
  ToastUtils._();

  static void showSuccessToast(BuildContext context, String message) {
    showToastWidget(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20.0),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      context: context,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 2500),
      animation: StyledToastAnimation.slideToBottom,
      position: StyledToastPosition.bottom,
      dismissOtherToast: true,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    showToastWidget(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20.0),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      context: context,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 2500),
      animation: StyledToastAnimation.slideToBottom,
      position: StyledToastPosition.bottom,
      dismissOtherToast: true,
    );
  }
}
