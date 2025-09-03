import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_cubit.dart';

class EditPostPage extends StatefulWidget {
  final PostModel post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption);
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedPost = widget.post.copyWith(caption: _captionController.text);

    widget.post == updatedPost
        ? ToastUtils.showSuccessToast(
            context,
            'Looks like your Post is already up to date — no changes were made.',
          )
        : context.read<PostCubit>().updatePost(updatedPost);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Caption"),
        actions: [
          TextButton(onPressed: _saveChanges, child: const Text('Save')),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: 'post-image-${widget.post.id}',
            child: Image.network(
              widget.post.imageUrls.first,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: 'Edit Caption',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
