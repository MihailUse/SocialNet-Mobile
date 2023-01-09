import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("HH:mm");
    final author = post.author;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async => await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profile, arguments: author.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage: author.avatarLink == null
                  ? const AssetImage("./assets/person.jpg") as ImageProvider
                  : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(author.avatarLink!)),
              backgroundImage: const AssetImage("./assets/person.jpg"),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(author.nickname, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(dateFormat.format(post.createdAt), style: Theme.of(context).textTheme.bodySmall),
              ],
            )
          ],
        ),
      ),
    );
  }
}
