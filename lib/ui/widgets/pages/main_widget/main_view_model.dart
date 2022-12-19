import 'package:flutter/material.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/services/user_service.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel() {
    asyncInit();
  }

  int selectedPageIndex = 0;
  late UserProfileModel user;
  final _userService = UserService();

  void onItemTapped(int index) async {
    selectedPageIndex = index;
    user = await _userService.getCurrentUserProfile();
    notifyListeners();
  }

  void asyncInit() async {
    user = await _userService.getCurrentUserProfile();
  }
}
