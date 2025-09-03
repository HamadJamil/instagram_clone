// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/features/home_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_state.dart';

class PostCaptionPage extends StatefulWidget {
  final List<File> selectedImages;
  final String user;

  const PostCaptionPage({
    super.key,
    required this.selectedImages,
    required this.user,
  });

  @override
  State<PostCaptionPage> createState() => _PostCaptionPageState();
}

class _PostCaptionPageState extends State<PostCaptionPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Caption'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final shouldDiscard = await _showDiscardDialog(context);

            if (shouldDiscard == true) {
              context.read<GalleryCubit>().reset();
              Navigator.pop(context);
              context.read<NavigationCubit>().navigateToHome();
            }
          },
        ),

        actions: [
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              return state is PostLoading
                  ? Container(
                      margin: EdgeInsets.only(right: 16.0),
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      onPressed: state is! PostLoading
                          ? () => _createPost(context)
                          : null,
                      child: const Text('Post'),
                    );
            },
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostError) {
            ToastUtils.showErrorToast(context, state.message);
          }
          if (state is PostCreated) {
            ToastUtils.showSuccessToast(context, 'Post created successfully');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: widget.selectedImages.length == 1
                    ? Image.file(widget.selectedImages[0])
                    : PageView.builder(
                        itemCount: widget.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Image.file(widget.selectedImages[index]);
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Caption (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _createPost(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<PostCubit>().createPost(
      widget.user,
      _controller.text,
      widget.selectedImages,
    );
    context.read<GalleryCubit>().reset();
    context.read<NavigationCubit>().navigateToHome();
  }

  Future<bool?> _showDiscardDialog(BuildContext context) async {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard Post?'),
          content: const Text('Are you sure you want to discard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }
}
