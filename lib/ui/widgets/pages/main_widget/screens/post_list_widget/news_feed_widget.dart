import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/common/post_widget/post_widget.dart';
import 'package:social_net/ui/widgets/pages/main_widget/screens/post_list_widget/news_feed_view_model.dart';

class NewsFeedWidget extends StatelessWidget {
  const NewsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<NewsFeedViewModel>();
    final posts = context.select((NewsFeedViewModel value) => value.posts);

    return CustomScrollView(
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
            onPressed: viewmodel.onAddPostButtonPressed,
            icon: const Icon(Icons.add),
          ),
          actions: [
            IconButton(
              onPressed: viewmodel.onNotificationsButtonPressed,
              icon: const Icon(Icons.notifications),
            ),
            const SizedBox(width: 8),
          ],
        ),
        if (posts == null)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(viewmodel.posts!.length, (index) {
                return PostWidget(
                  postIndex: index,
                  post: viewmodel.posts![index],
                );
              }),
            ),
          )
      ],
    );
  }

  static Widget create() => ChangeNotifierProvider<NewsFeedViewModel>(
        lazy: false,
        create: (context) => NewsFeedViewModel(context),
        child: const NewsFeedWidget(),
      );
}
