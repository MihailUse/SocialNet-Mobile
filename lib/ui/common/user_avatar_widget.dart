import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Theme.of(context).shadowColor),
        ],
      ),
      child: CircleAvatar(
        minRadius: 32,
        maxRadius: 86,
        foregroundImage: CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(userId)),
        backgroundImage: const AssetImage("./assets/person.jpg"),
      ),
    );
  }
}
