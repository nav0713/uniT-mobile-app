import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: CachedNetworkImage(
        imageUrl:
        "https://live.staticflickr.com/7320/9052838885_af9b21c79b_b.jpg",
            // 'https://static.vecteezy.com/system/resources/thumbnails/008/074/253/small/tropical-forest-sunset-nature-background-with-coconut-trees-vector.jpg',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}
