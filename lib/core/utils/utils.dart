import 'package:flutter/material.dart';

void showErrorSnackbar(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: backgroundColor),
  );
}

Widget buildLoadingIndicator(Color color) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(color),
  );
}

String getMessageFromErrorCode(String code) {
  switch (code) {
    case 'user-not-found':
      return 'User not found';
    case 'wrong-password':
      return 'Wrong password';
    case 'email-already-in-use':
      return 'Email already in use';
    case 'weak-password':
      return 'Weak password';
    case 'too-many-requests':
      return 'Too many requests';
    default:
      return 'Unknown error';
  }
}
