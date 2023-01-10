import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/post_list_widget/post_list_widget.dart';
import 'package:social_net/ui/widgets/common/profile_count_detail_widget.dart';
import 'package:social_net/ui/widgets/common/user_avatar_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/profile_widget/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.asyncInit(viewModel.user?.id);
          await viewModel.postListViewModel.asyncInit();
        },
        child: CustomScrollView(
          controller: viewModel.postListViewModel.scrollController,
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
            const SliverPadding(
              padding: EdgeInsets.all(24.0),
              sliver: _ProfileInfo(),
            ),
            if (viewModel.postListViewModel.posts == null || viewModel.postListViewModel.posts!.isEmpty)
              SliverFillRemaining(
                child: Center(
                    child: viewModel.postListViewModel.posts == null
                        ? const CircularProgressIndicator()
                        : const Text("posts not found")),
              )
            else
              ChangeNotifierProvider.value(
                value: viewModel.postListViewModel,
                child: const PostListWidget(),
              ),
          ],
        ),
      ),
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
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 86.0, vertical: 24.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Theme.of(context).shadowColor),
              ],
            ),
            child: UserAvatarWidget(
              minRadius: 86,
              avatarLink: user.avatarLink,
            ),
          ),
        ),
        Text(
          user.nickname,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              children: [
                ProfileCountDetailWidget(
                  value: user.postCount == null ? "..." : viewModel.parseCount(user.postCount!),
                  description: "publications",
                ),
                ProfileCountDetailWidget(
                  value: user.followerCount == null ? "..." : viewModel.parseCount(user.followerCount!),
                  description: "followers",
                ),
                ProfileCountDetailWidget(
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
      ]),
    );
  }
}
