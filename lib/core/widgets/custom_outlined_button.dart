import 'package:flutter/material.dart';
import 'package:instagram/core/utils/utils.dart';

class CustomOutlinedButton extends StatefulWidget {
  const CustomOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEmailSent,
  });

  final String label;
  final void Function() onPressed;
  final void Function(bool isEmailSent)? isEmailSent;

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _isLoading ? null : () => widget.onPressed(),
      child: _isLoading
          ? buildLoadingIndicator(Colors.blue)
          : Text(widget.label),
    );
  }
}
