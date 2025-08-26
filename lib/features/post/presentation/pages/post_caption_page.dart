import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/features/post/data/datasources/firestore_post_service.dart';
import 'package:instagram/features/post/data/repositories/firestore_post_repository_implementation.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';
import 'package:instagram/features/post/presentation/cubits/post_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:instagram/features/feed/presentation/pages/feed_page.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

// Need to get user via State (Fixed)
// Need to fix Post Cubit Dependency
// Show Success & Error Snackbar
// Clear Selection Image after Posted(Implement this Function In PostCubit)

class PostCaptionPage extends StatefulWidget {
  const PostCaptionPage({
    super.key,
    required this.selectedImages,
    required this.userId,
  });
  final List<AssetEntity> selectedImages;
  final String userId;

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
      body: BlocProvider(
        create: (context) => PostCubit(
          postRepository: FirestorePostRepositoryImplementation(
            FirestorePostService(),
          ),
        ),
        child: BlocListener<PostCubit, PostPageState>(
          listener: (context, state) {
            if (state is PostPagePostCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post Created Successfully')),
              );
              // Need to change to Go Router
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => FeedPage()),
              );
            } else if (state is PostPageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Column(
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
                    : CarouselSlider(
                        items: _selectedImageFiles.map((e) {
                          return PhotoView(imageProvider: FileImage(e));
                        }).toList(),
                        options: CarouselOptions(
                          height: 300,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                        ),
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
                          userId: widget.userId,
                          imageUrls: [],
                          caption: _controller.text,
                          createdAt: DateTime.now(),
                        );
                        context.read<PostCubit>().createPost(postModel);
                      },
                      child: state is PostPageLoading
                          ? const CircularProgressIndicator()
                          : const Text('Share'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
