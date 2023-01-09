import 'package:flutter/material.dart';

class PostCarouselIndicatorWidget extends StatelessWidget {
  final int count;
  final int currentIndex;
  const PostCarouselIndicatorWidget({Key? key, required this.count, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Icon(
              size: 14.0,
              i == currentIndex ? Icons.circle : Icons.circle_outlined,
            ),
        ],
      ),
    );
  }
}
