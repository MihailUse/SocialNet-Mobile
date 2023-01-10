import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/post_list_widget/post_list_widget.dart';
import 'package:social_net/ui/widgets/tab_home/home_widget/home_view_model.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return RefreshIndicator(
      onRefresh: viewModel.postListViewModel.asyncInit,
      child: CustomScrollView(
        controller: viewModel.postListViewModel.scrollController,
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
    );
  }

  static Widget create() => ChangeNotifierProvider<HomeViewModel>(
        lazy: false,
        create: (context) => HomeViewModel(context),
        child: const HomeWidget(),
      );
}
