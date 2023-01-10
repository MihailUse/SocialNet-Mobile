import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.avatarLink,
    this.radius,
    this.minRadius,
    this.maxRadius,
  });

  final String? avatarLink;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      foregroundImage: avatarLink == null
          ? const AssetImage("./assets/person.jpg")
          : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(avatarLink!)) as ImageProvider,
      backgroundImage: const AssetImage("./assets/person.jpg"),
    );
  }
}
