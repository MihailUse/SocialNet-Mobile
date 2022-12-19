import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/pages/main_widget/main_view_model.dart';
import 'package:social_net/ui/widgets/pages/main_widget/screens/post_list_widget/news_feed_widget.dart';
import 'package:social_net/ui/widgets/pages/main_widget/screens/profile_widget/profile_widget.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  static final pages = <Widget>{
    NewsFeedWidget.create(),
    ProfileWidget.create(),
    ProfileWidget.create(),
  };

  @override
  Widget build(BuildContext context) {
    final selectedPageIndex = context.select((MainViewModel value) => value.selectedPageIndex);

    return Scaffold(
      body: SafeArea(
        child: pages.elementAt(selectedPageIndex),
      ),
      bottomNavigationBar: const _NavigationBarWidget(),
    );
  }

  static Widget create() => ChangeNotifierProvider<MainViewModel>(
        lazy: false,
        create: (_) => MainViewModel(),
        child: const MainWidget(),
      );
}

class _NavigationBarWidget extends StatelessWidget {
  const _NavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<MainViewModel>();
    final selectedPageIndex = context.select((MainViewModel value) => value.selectedPageIndex);

    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: viewmodel.onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Posts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tag),
          label: "Tags",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
