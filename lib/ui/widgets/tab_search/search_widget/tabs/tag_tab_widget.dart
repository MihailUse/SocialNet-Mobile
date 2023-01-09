import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/cards/tag_card_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_view_model.dart';

class TagTabWidget extends StatelessWidget {
  const TagTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = context.select((SearchViewModel value) => value.tags);

    if (tags.isEmpty) {
      return const Center(
        child: Text("not found"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          tags.length,
          (index) => TagCardWidget(tag: tags[index]),
        ),
      ),
    );
  }
}
