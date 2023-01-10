import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/post_list_widget/post_list_view_model.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.context) {
    postListViewModel = PostListViewModel.personal(context);
    postListViewModel.addListener(notifyListeners);
  }

  final BuildContext context;
  late final PostListViewModel postListViewModel;

  void onAddPostButtonPressed() async {
    await Navigator.of(context).pushNamed(NestedNavigatorRoutes.postCreate);
  }

  void onNotificationsButtonPressed() {
    final mainViewModel = context.read<MainViewModel>();
    mainViewModel.onSelectTab(MainNavigatorRoutes.notifications);
  }
}
