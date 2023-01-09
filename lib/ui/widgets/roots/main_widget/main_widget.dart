import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/widgets/common/bottom_navigation_bar_widget.dart';
import 'package:social_net/ui/widgets/common/nested_navigator_widget.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    
    Widget buildOffstageNavigator(MainNavigatorRoutes tabItem) {
      return Offstage(
        offstage: viewModel.currentTab != tabItem,
        child: SafeArea(
          child: NestedNavigatorWidget(
            tabItem: tabItem,
            navigatorKey: viewModel.navigationKeys[tabItem]!,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          final isRootTab = await viewModel.navigationKeys[viewModel.currentTab]!.currentState!.maybePop();

          if (isRootTab) {
            if (viewModel.currentTab != MainNavigator.initialRoute) {
              viewModel.onSelectTab(MainNavigator.initialRoute);
            }

            return false;
          }

          return isRootTab;
        },
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBarWidget(
            currentTab: viewModel.currentTab,
            onSelectTab: viewModel.onSelectTab,
          ),
          body: Stack(
            children: MainNavigatorRoutes.values.map((tabItem) => buildOffstageNavigator(tabItem)).toList(),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<MainViewModel>(
        lazy: false,
        create: (context) => MainViewModel(context),
        child: const MainWidget(),
      );
}
