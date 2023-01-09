import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/services/post_service.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';

class PostFooterWidget extends StatefulWidget {
  PostFooterWidget({super.key, required this.post});

  PostModel post;
  final postService = PostService();

  @override
  State<PostFooterWidget> createState() => _PostFooterWidgetState();
}

class _PostFooterWidgetState extends State<PostFooterWidget> {
  void onLikeButtonPressed() async {
    final isLiked = await widget.postService.changePostLikeStatus(widget.post.id);
    final likeCount = isLiked ? widget.post.likeCount + 1 : widget.post.likeCount - 1;

    setState(() {
      widget.post = widget.post.copyWith(likeCount: likeCount, isLiked: isLiked);
    });
  }

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
                Icon(widget.post.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
                const SizedBox(width: 6.0),
                Text(widget.post.likeCount.toString()),
              ],
            ),
          ),
          const SizedBox(width: 6.0),
          if (widget.post.isCommentable)
            OutlinedButton(
              onPressed: () async =>
                  await Navigator.of(context).pushNamed(NestedNavigatorRoutes.commentList, arguments: widget.post.id),
              child: Row(
                children: [
                  const Icon(Icons.messenger_outline_rounded),
                  const SizedBox(width: 6.0),
                  Text(widget.post.commentCount.toString()),
                ],
              ),
            )
        ],
      ),
    );
  }
}
