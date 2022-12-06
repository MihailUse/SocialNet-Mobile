import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/app_navigator.dart';
import 'package:social_net/ui/widgets/profile_widget.dart';

class MainViewModel extends ChangeNotifier {
  int selectedPageIndex = 0;

  void onItemTapped(int index) {
    // TODO: remove this
    if (index == 2) {
      final authService = AuthService();
      authService.logout();
      AppNavigator.toLoader();
    }

    selectedPageIndex = index;
    notifyListeners();
  }
}

class MainWidget extends StatelessWidget {
  static final routes = <Widget>{
    ProfileWidget.create(),
    ProfileWidget.create(),
    ProfileWidget.create(),
  };

  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPageIndex = context.select((MainViewModel value) => value.selectedPageIndex);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: routes.elementAt(selectedPageIndex),
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
          icon: Icon(Icons.person),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "home1",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: "logout",
        ),
      ],
    );
  }
}
