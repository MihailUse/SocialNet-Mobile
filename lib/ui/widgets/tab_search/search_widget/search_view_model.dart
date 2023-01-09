import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';

enum SearchTabs {
  all,
  tags,
  users,
}

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this.context, String searchText) {
    asyncInit();

    searchController = TextEditingController(text: searchText);
    searchController.addListener(() => search = searchController.text);
    search = searchText;
  }

  var _search = "";
  List<Tag> tags = [];
  List<User> users = [];
  List<PostModel> posts = [];
  var currentTab = SearchTabs.all;
  final _databaseService = DatabaseService();
  final _syncService = SyncService();
  final BuildContext context;
  late final TextEditingController searchController;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String get search => _search;
  set search(String search) {
    _search = search;
    asyncInit();
  }

  Icon get searchIcon {
    switch (currentTab) {
      case SearchTabs.all:
        return const Icon(Icons.search);
      case SearchTabs.tags:
        return const Icon(Icons.tag);
      case SearchTabs.users:
        return const Icon(Icons.alternate_email);
    }
  }

  void asyncInit() async {
    final limit = currentTab == SearchTabs.all ? 3 : 20;

    try {
      switch (currentTab) {
        case SearchTabs.all:
          await _syncService.syncSearchTags(search: search, take: limit);
          await _syncService.syncSearchUsers(search: search, take: limit);
          break;

        case SearchTabs.tags:
          await _syncService.syncSearchTags(search: search, take: limit);
          break;

        case SearchTabs.users:
          await _syncService.syncSearchUsers(search: search, take: limit);
          break;
      }
    } catch (e) {
      showError("failed to get ${currentTab.name} search list");
    }

    users = await _databaseService.searchUsers(search, 0, limit);
    tags = await _databaseService.searchTags(search, 0, limit);
    notifyListeners();
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void onTabChenged(int value) {
    currentTab = SearchTabs.values[value];
    asyncInit();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
  }
}
