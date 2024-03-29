import 'package:flutter/material.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/user_avatar_widget.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profile, arguments: user.id),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatarWidget(avatarLink: user.avatarLink),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.nickname),
                    Text("followers: ${user.followerCount}", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
