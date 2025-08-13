import 'package:flutter/material.dart';

showErrorSnackbar(BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: backgroundColor),
  );
}

buildLoadingIndicator(Color color) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(color),
  );
}
