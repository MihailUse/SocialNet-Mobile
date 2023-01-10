import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';

enum SearchTab {
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

  String _search = "";
  List<TagModel> tags = [];
  List<User> users = [];
  List<PostModel> posts = [];
  SearchTab currentTab = SearchTab.all;
  final _databaseService = DatabaseService();
  final _syncService = SyncService();
  final BuildContext context;
  final scrollController = ScrollController();
  late final TextEditingController searchController;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String get search => _search;
  set search(String search) {
    _search = search;
    asyncInit();
  }

  Icon get searchIcon {
    switch (currentTab) {
      case SearchTab.all:
        return const Icon(Icons.search);
      case SearchTab.tags:
        return const Icon(Icons.tag);
      case SearchTab.users:
        return const Icon(Icons.alternate_email);
    }
  }

  Future<void> asyncInit() async {
    try {
      switch (currentTab) {
        case SearchTab.all:
          await _syncService.syncSearchTags(search: search);
          await _syncService.syncSearchUsers(search: search);
          break;

        case SearchTab.tags:
          await _syncService.syncSearchTags(search: search);
          break;

        case SearchTab.users:
          await _syncService.syncSearchUsers(search: search);
          break;
      }
    } catch (e) {
      showError("failed to get ${currentTab.name} search list");
    }

    users = await _databaseService.searchUsers(search);
    tags = await _databaseService.searchTags(search);
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
    currentTab = SearchTab.values[value];
    asyncInit();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
  }
}
