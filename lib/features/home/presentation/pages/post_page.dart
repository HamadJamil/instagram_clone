import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/home/presentation/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<AssetEntity> assets = [
    AssetEntity(id: '1', typeInt: 0, height: 10, width: 10),
  ];
  late Future<File?> imageFile;

  Future<void> _loadAssets() async {
    assets.addAll(await PhotoManager.getAssetListRange(start: 0, end: 100));
    imageFile = assets[1].file;
    setState(() {});
  }

  @override
  void initState() {
    _loadAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: () {
              //////////
            },
            child: const Text(
              "Next",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.red,
              height: size.height * 0.5,
              child: _buildSelectedPicture(imageFile),
            ),
          ),
          SliverAppBar(
            titleSpacing: 5,
            title: Text('Recent'),
            automaticallyImplyLeading: false,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.content_copy_outlined),
              ),
            ],
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return index == 0
                  ? Container(
                      color: AppColors.primary,
                      child: Icon(Icons.camera_alt),
                    )
                  : AssetThumbnail(asset: asset);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPicture(Future<File?> imageFile) {
    return FutureBuilder<File?>(
      future: imageFile.then((file) => file!),
      builder: (_, snapshot) {
        final file = snapshot.data;
        if (file == null) {
          return Center(child: Icon(Icons.image));
        }
        return PhotoView(imageProvider: FileImage(file));
      },
    );
  }
}
