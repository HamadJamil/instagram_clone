import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final TextInputType? keyBoard;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.textController,
    this.keyBoard = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyBoard,
      controller: textController,
      decoration: InputDecoration(label: Text(label)),
      validator: validator,
    );
  }
}
