import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/user_avatar_widget.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final author = post.author;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async => await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profile, arguments: author.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatarWidget(avatarLink: author.avatarLink),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(author.nickname, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(DateFormat.yMEd().format(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
              ],
            )
          ],
        ),
      ),
    );
  }
}
