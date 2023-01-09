import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/ui/widgets/common/count_detail_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/profile_widget/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          actions: [
            if (viewModel.isCurrentUser)
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Menu',
                onPressed: viewModel.onProfileMenuPressed,
              ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const _ProfileInfo(),
              const SizedBox(height: 1000),
            ],
          ),
        )
      ],
    );
  }

  static Widget create([String? userId]) => ChangeNotifierProvider<ProfileViewModel>(
        lazy: false,
        create: (context) => ProfileViewModel(context, userId),
        child: const ProfileWidget(),
      );
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileViewModel>();
    final user = context.select((ProfileViewModel value) => value.user);

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 86.0, vertical: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(blurRadius: 10, color: Theme.of(context).shadowColor),
                ],
              ),
              child: CircleAvatar(
                minRadius: 32,
                maxRadius: 86,
                foregroundImage: user.avatarLink == null
                    ? const AssetImage("./assets/person.jpg") as ImageProvider
                    : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(user.avatarLink!)),
                backgroundImage: const AssetImage("./assets/person.jpg"),
              ),
            ),
          ),
          Text(
            user.nickname,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CountDetailWidget(
                value: user.postCount == null ? "..." : viewModel.parseCount(user.postCount!),
                description: "publications",
              ),
              CountDetailWidget(
                value: user.followerCount == null ? "..." : viewModel.parseCount(user.followerCount!),
                description: "followers",
              ),
              CountDetailWidget(
                value: user.followingCount == null ? "..." : viewModel.parseCount(user.followingCount!),
                description: "followings",
              )
            ],
          ),
          if (user.about != null && user.about!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(user.about!),
            ),
          if (!viewModel.isCurrentUser)
            if (user.isFollowing == true)
              OutlinedButton(
                onPressed: viewModel.changeFollowStatus,
                child: const Text("unfollow"),
              )
            else
              ElevatedButton(
                onPressed: viewModel.changeFollowStatus,
                child: const Text("follow"),
              )
        ],
      ),
    );
  }
}
