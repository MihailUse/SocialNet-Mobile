import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_carousel_widget.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_footer_widget.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_header_widget.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

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
      final mainViewModel = context.read<MainViewModel>();
      String startString = post.text!;
      final splittedText = startString.split(" ");
      final pattern = RegExp(r'\B(#+[a-zA-Z0-9(_)]{1,})');
      final List<TextSpan> result = [];

      for (final text in splittedText) {
        final isTag = text.contains(pattern);
        final textSpan = isTag
            ? TextSpan(
                text: "$text ",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Navigator.of(mainViewModel.navigationKeys[MainNavigatorRoutes.search]!.currentContext!)
                        .pushNamed(NestedNavigatorRoutes.search, arguments: text)
                        .then((value) => mainViewModel.onSelectTab(MainNavigatorRoutes.search));
                  },
              )
            : TextSpan(
                text: "$text ",
                style: Theme.of(context).textTheme.bodyText2,
              );

        result.add(textSpan);
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
