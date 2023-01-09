import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/cards/user_card_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_view_model.dart';

class UserTabWidget extends StatelessWidget {
  const UserTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.select((SearchViewModel value) => value.users);

    if (users.isEmpty) {
      return const Center(
        child: Text("not found"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          users.length,
          (index) => UserCardWidget(user: users[index]),
        ),
      ),
    );
  }
}
