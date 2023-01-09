import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_card_widget.dart';

class SliverPostListWidget extends StatelessWidget {
  const SliverPostListWidget({
    super.key,
    required this.posts,
    required this.onLikeButtonPressed,
    required this.onCommentButtonPressed,
  });

  final List<PostModel> posts;
  final Function(String) onLikeButtonPressed;
  final Function(String) onCommentButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(posts.length, (index) {
          final post = posts[index];

          return PostCardWidget(
            post: post,
            onLikeButtonPressed: () => onLikeButtonPressed(post.id),
            onCommentButtonPressed: () => onCommentButtonPressed(post.id),
          );
        }),
      ),
    );
  }
}
