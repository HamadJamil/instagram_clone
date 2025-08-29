import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/features/post/presentation/cubits/post_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

// Need to get user via State (Fixed)
// Need to fix Post Cubit Dependency(Fixed)
// Show Success & Error Snackbar
// Clear Selection Image after Posted(Implement this Function In PostCubit)

class PostCaptionPage extends StatefulWidget {
  const PostCaptionPage({
    super.key,
    required this.selectedImages,
    required this.user,
  });
  final List<AssetEntity> selectedImages;
  final UserModel user;

  @override
  State<PostCaptionPage> createState() => _PostCaptionPageState();
}

class _PostCaptionPageState extends State<PostCaptionPage> {
  late TextEditingController _controller;
  late List<File> _selectedImageFiles;

  @override
  void initState() {
    _controller = TextEditingController();
    _selectedImageFiles = [];
    convertAssetEntityListToFileList(widget.selectedImages).then((files) {
      setState(() {
        _selectedImageFiles = files;
      });
    });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Add Caption'),
        centerTitle: false,
      ),
      body: BlocConsumer<PostCubit, PostPageState>(
        listener: (context, state) {
          if (state is PostPageError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is PostPagePostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _selectedImageFiles.length == 1
                    ? PhotoView(
                        imageProvider: FileImage(_selectedImageFiles[0]),
                      )
                    : PageView.builder(
                        itemCount: _selectedImageFiles.length,
                        itemBuilder: (context, index) {
                          return PhotoView(
                            imageProvider: FileImage(
                              _selectedImageFiles[index],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: CustomTextFormField(
                  label: 'Caption(Optional)',
                  textController: _controller,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BlocBuilder<PostCubit, PostPageState>(
                  builder: (context, state) {
                    return OutlinedButton(
                      onPressed: () {
                        PostModel postModel = PostModel(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          authorId: widget.user.uid,
                          authorName: widget.user.name,
                          authorImage: widget.user.photoUrl,
                          imageUrls: [],
                          caption: _controller.text,
                          createdAt: DateTime.now(),
                        );
                        context.read<PostCubit>().createPost(
                          postModel,
                          _selectedImageFiles,
                        );
                      },
                      child: state is PostPageLoading
                          ? const CircularProgressIndicator()
                          : const Text('Share'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
