import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/cards/tag_card_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/cards/user_card_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_view_model.dart';

class AllTabWidget extends StatelessWidget {
  const AllTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.select((SearchViewModel value) => value.users);
    final tags = context.select((SearchViewModel value) => value.tags);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ListLabel("Tags"),
          if (tags.isEmpty)
            const Center(child: Text("not found"))
          else
            ...List.generate(
              min(tags.length, 3),
              (index) => TagCardWidget(tag: tags[index]),
            ),
          const _ListLabel("Users"),
          if (users.isEmpty)
            const Center(child: Text("not found"))
          else
            ...List.generate(
              min(users.length, 3),
              (index) => UserCardWidget(user: users[index]),
            ),
        ],
      ),
    );
  }
}

class _ListLabel extends StatelessWidget {
  const _ListLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Text(title, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18)),
    );
  }
}
