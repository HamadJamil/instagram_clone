import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/models/post_model.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 20, child: Icon(Icons.person)),
                SizedBox(width: 8),
                Text(
                  '${post.userId}\n${post.createdAt}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: post.imageUrls.length == 1
                ? CachedNetworkImage(
                    imageUrl: post.imageUrls.first,
                    fit: BoxFit.cover,
                  )
                : CarouselSlider(
                    items: post.imageUrls.map((url) {
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.favorite_border),
                label: Text('${post.likes} Like'),
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text('${post.comments} Comments'),
                icon: Icon(Icons.messenger_outline_rounded),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              post.caption ?? '',
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
