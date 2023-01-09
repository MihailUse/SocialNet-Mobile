import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/sliver_post_list_widget.dart';
import 'package:social_net/ui/widgets/tab_home/home_widget/home_view_model.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    final posts = context.select((HomeViewModel value) => value.posts);

    return RefreshIndicator(
      key: viewModel.refreshIndicatorKey,
      onRefresh: viewModel.updateList,
      child: CustomScrollView(
        controller: viewModel.scrollController,
        slivers: [
          SliverAppBar(
            leadingWidth: 200,
            floating: true,
            leading: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Colors.transparent,
                elevation: 220.0,
              ),
              label: const Text("New post"),
              onPressed: viewModel.onAddPostButtonPressed,
              icon: const Icon(Icons.add),
            ),
            actions: [
              IconButton(
                onPressed: viewModel.onNotificationsButtonPressed,
                icon: const Icon(Icons.notifications),
              ),
              const SizedBox(width: 8),
            ],
          ),
          posts == null
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : SliverPostListWidget(
                  posts: posts,
                  onLikeButtonPressed: viewModel.onLikeButtonPressed,
                  onCommentButtonPressed: viewModel.onCommentButtonPressed,
                ),
        ],
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<HomeViewModel>(
        lazy: false,
        create: (context) => HomeViewModel(context),
        child: const HomeWidget(),
      );
}
