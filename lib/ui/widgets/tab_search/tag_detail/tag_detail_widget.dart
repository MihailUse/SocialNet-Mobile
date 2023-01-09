import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/ui/widgets/common/count_detail_widget.dart';
import 'package:social_net/ui/widgets/tab_search/tag_detail/tag_detail_view_model.dart';

class TagDetailWidgetArguments {
  final Tag tag;
  final Function()? onChanged;

  TagDetailWidgetArguments({
    required this.tag,
    this.onChanged,
  });
}

class TagDetailWidget extends StatelessWidget {
  const TagDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TagDetailViewModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(viewModel.tag.name),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 86.0, vertical: 16.0),
                    child: CircleAvatar(
                      minRadius: 48,
                      child: Text("#", textScaleFactor: 3),
                    ),
                  ),
                  Text(
                    viewModel.tag.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CountDetailWidget(
                        value: viewModel.tag.postCount.toString(),
                        description: "posts",
                      ),
                      CountDetailWidget(
                        value: viewModel.tag.followerCount.toString(),
                        description: "followers",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.tag.isFollowed)
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
            ),
          )
        ],
      ),
    );
  }

  static Widget create(TagDetailWidgetArguments arguments) =>
      ChangeNotifierProvider<TagDetailViewModel>(
        lazy: false,
        create: (context) => TagDetailViewModel(context, arguments.tag, arguments.onChanged),
        child: const TagDetailWidget(),
      );
}
