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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[500]!),
      ),
      child: TextFormField(
        keyboardType: keyBoard,
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
        ),
        validator: validator,
      ),
    );
  }
}
