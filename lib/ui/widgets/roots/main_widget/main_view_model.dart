import 'package:flutter/material.dart';
import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel(this.context) {
    asyncInit();
  }

  var _currentTab = MainNavigator.initialRoute;
  final BuildContext context;
  final _syncService = SyncService();
  final _databaseService = DatabaseService();
  final navigationKeys = {
    MainNavigatorRoutes.home: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.search: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.profile: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.notifications: GlobalKey<NavigatorState>(),
  };

  MainNavigatorRoutes get currentTab => _currentTab;
  set currentTab(MainNavigatorRoutes value) {
    _currentTab = value;
    notifyListeners();
  }

  UserProfileModel? _user;
  UserProfileModel? get user => _user;
  set user(UserProfileModel? value) {
    _user = value;
    notifyListeners();
  }

  Future<void> asyncInit() async {
    try {
      await _syncService.syncCurrentUser();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed load profile info"),
        ),
      );
    }

    final currentUserId = await LocalStorage.instance.getValue(LocalStorageKeys.currentUserId);
    if (currentUserId == null) {
      await AppNavigator.toAuth();
      return;
    }

    user = await _databaseService.getUserById(currentUserId);
  }

  void onSelectTab(MainNavigatorRoutes value) {
    if (currentTab == value) {
      // navigate to root tab
      navigationKeys[value]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      currentTab = value;
    }
  }
}
