import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key, required this.onSend});
  final void Function(String content) onSend;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              autofocus: true,
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: 'Add a comment...',
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey400,
                  ),
                  child: const Icon(Icons.person, size: 20),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        widget.onSend(text);
                        textController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
