import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/common/post_widget/post_carousel_widget.dart';
import 'package:social_net/ui/common/post_widget/post_footer_widget.dart';
import 'package:social_net/ui/common/post_widget/post_header_widget.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.postIndex,
  });

  final PostModel post;
  final int postIndex;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void onLikeButtonPressed(int postIndex) {}

  void onCommentButtonPressed(int postIndex) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeaderWidget(post: widget.post),
            if (widget.post.text != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.post.text!,
                  textAlign: TextAlign.start,
                ),
              ),
            if (widget.post.attaches!.isNotEmpty) PostCarouselWidget(post: widget.post),
            const Divider(),
            PostFooterWidget(
              post: widget.post,
              onLikeButtonPressed: () => onLikeButtonPressed(widget.postIndex),
              onCommentButtonPressed: () => onCommentButtonPressed(widget.postIndex),
            )
          ],
        ),
      ),
    );
  }
}
