import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({super.key, required this.postId, required this.attachId});

  final String postId;
  final String attachId;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: ApiRepository.getPostAttachPath(postId, attachId));
  }
}
