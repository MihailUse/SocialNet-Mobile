import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_card_widget.dart';
import 'package:social_net/ui/widgets/common/post_list_widget/post_list_view_model.dart';

class PostListWidget extends StatelessWidget {
  const PostListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostListViewModel>();

    List<Widget> postList = List.generate(
      viewModel.posts?.length ?? 0,
      (index) => PostCardWidget(
        post: viewModel.posts![index],
        onLikeButtonPressed: viewModel.onLikeButtonPressed,
      ),
    );

    if (viewModel.isLoading) {
      postList.add(const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      )));
    }

    return SliverList(
      delegate: SliverChildListDelegate(postList),
    );
  }
}
