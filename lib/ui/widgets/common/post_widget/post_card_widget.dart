import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/widgets/common/post_widget/post_carousel_widget.dart';
import 'package:social_net/ui/widgets/common/post_widget/post_footer_widget.dart';
import 'package:social_net/ui/widgets/common/post_widget/post_header_widget.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    required this.onLikeButtonPressed,
    required this.onCommentButtonPressed,
  });

  final PostModel post;
  final Function() onLikeButtonPressed;
  final Function() onCommentButtonPressed;

  @override
  Widget build(BuildContext context) {
    TextSpan generateRichText() {
      String startString = post.text!;
      final splittedText = startString.split(" ");
      final pattern = RegExp(r'\B(#+[a-zA-Z0-9(_)]{1,})');
      final List<TextSpan> result = [];

      for (final part in splittedText) {
        final isTag = part.contains(pattern);

        result.add(
          TextSpan(
            text: "$part ",
            style: isTag
                ? Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue)
                : Theme.of(context).textTheme.bodyText2,
          ),
        );
      }

      return TextSpan(children: result);
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeaderWidget(post: post),
            if (post.text != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  text: generateRichText(),
                  textAlign: TextAlign.start,
                ),
              ),
            if (post.attaches!.isNotEmpty)
              PostCarouselWidget(
                post: post,
              ),
            const Divider(),
            PostFooterWidget(post: post)
          ],
        ),
      ),
    );
  }
}
