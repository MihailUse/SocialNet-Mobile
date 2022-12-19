import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/common/user_avatar_widget.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("HH:mm");
    final author = post.author;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (author.avatar == null)
            const CircleAvatar(backgroundImage: AssetImage("./assets/person.jpg"))
          else
            UserAvatarWidget(userId: author.id),
          const SizedBox(width: 16),
          Column(
            children: [
              Text(author.nickname),
              const SizedBox(height: 2),
              Text(dateFormat.format(post.createdAt)),
            ],
          )
        ],
      ),
    );
  }
}
