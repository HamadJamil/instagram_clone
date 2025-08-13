import 'package:flutter/material.dart';
import 'package:instagram/core/utils/utils.dart';

class CustomFilledButton extends StatefulWidget {
  const CustomFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEmailSent,
  });

  final String label;
  final void Function() onPressed;
  final void Function(bool isEmailSent)? isEmailSent;

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isLoading
          ? null
          : () {
              widget.onPressed();
              widget.isEmailSent?.call(true);
            },
      child: _isLoading
          ? buildLoadingIndicator(Colors.black)
          : Text(widget.label),
    );
  }
}
