import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_view_model.dart';
import 'package:social_net/ui/widgets/common/tag_detail/tag_detail_widget.dart';

class TagCardWidget extends StatelessWidget {
  const TagCardWidget({super.key, required this.tag});

  final TagModel tag;

  @override
  Widget build(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        NestedNavigatorRoutes.tag,
        arguments: TagDetailWidgetArguments(tag: tag, onChanged: searchViewModel.asyncInit),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                child: Text("#"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag.name,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text("followers: ${tag.followerCount}", style: Theme.of(context).textTheme.bodySmall),
                    Text("posts: ${tag.postCount}", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (tag.isFollowed)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      "followed",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
