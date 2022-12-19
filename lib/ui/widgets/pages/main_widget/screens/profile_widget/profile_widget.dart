import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/common/user_avatar_widget.dart';
import 'package:social_net/ui/widgets/pages/main_widget/main_view_model.dart';
import 'package:social_net/ui/widgets/pages/main_widget/screens/profile_widget/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<ProfileViewModel>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menu',
              onPressed: viewmodel.onProfileMenuPressed,
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

  static Widget create() => ChangeNotifierProvider<ProfileViewModel>(
        lazy: false,
        create: (_) => ProfileViewModel(),
        child: const ProfileWidget(),
      );
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileViewModel>();
    final user = context.select((MainViewModel value) => value.user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 86.0, vertical: 16.0),
            child: UserAvatarWidget(userId: user.id),
          ),
          Text(
            user.nickname,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ProfileCountDetailWidget(
                value: viewModel.parseCount(user.postCount),
                description: "publications",
              ),
              _ProfileCountDetailWidget(
                value: viewModel.parseCount(user.followerCount),
                description: "followers",
              ),
              _ProfileCountDetailWidget(
                value: viewModel.parseCount(user.followingCount),
                description: "followings",
              )
            ],
          ),
          if (user.about != null && user.about!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(user.about!),
            ),
        ],
      ),
    );
  }
}

class _ProfileCountDetailWidget extends StatelessWidget {
  const _ProfileCountDetailWidget({required this.value, required this.description});

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
