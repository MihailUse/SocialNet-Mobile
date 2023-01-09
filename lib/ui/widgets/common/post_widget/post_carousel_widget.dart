import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/widgets/common/post_widget/post_image_widget.dart';
import 'package:social_net/ui/widgets/common/post_widget/post_carousel_indicator_widget.dart';

class PostCarouselWidget extends StatefulWidget {
  const PostCarouselWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<PostCarouselWidget> createState() => PostCarouselWidgetState();
}

class PostCarouselWidgetState extends State<PostCarouselWidget> {
  int currentAttachIndex = 0;

  void onAttachPageChanged(int pageIndex) {
    setState(() => currentAttachIndex = pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final postAttaches = widget.post.attaches!;

    return SizedBox(
      height: size.width * 0.9,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: onAttachPageChanged,
            itemCount: postAttaches.length,
            itemBuilder: (context, pageIndex) {
              return PostImageWidget(postId: widget.post.id, attachId: postAttaches[pageIndex].id);
            },
          ),
          if (postAttaches.length > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: PostCarouselIndicatorWidget(
                count: postAttaches.length,
                currentIndex: currentAttachIndex,
              ),
            ),
        ],
      ),
    );
  }
}
