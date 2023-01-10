import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';

class PostFooterWidget extends StatelessWidget {
  const PostFooterWidget({
    super.key,
    required this.post,
    required this.onLikeButtonPressed,
  });

  final PostModel post;
  final Function() onLikeButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: onLikeButtonPressed,
            child: Row(
              children: [
                Icon(post.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
                const SizedBox(width: 6.0),
                Text(post.likeCount.toString()),
              ],
            ),
          ),
          const SizedBox(width: 6.0),
          if (post.isCommentable)
            OutlinedButton(
              onPressed: () async =>
                  await Navigator.of(context).pushNamed(NestedNavigatorRoutes.commentList, arguments: post.id),
              child: Row(
                children: [
                  const Icon(Icons.messenger_outline_rounded),
                  const SizedBox(width: 6.0),
                  Text(post.commentCount.toString()),
                ],
              ),
            )
        ],
      ),
    );
  }
}
