import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_view_model.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/tabs/all_tab_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/tabs/tag_tab_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/tabs/user_tab_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: DefaultTabController(
          length: SearchTab.values.length,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: TextField(
                  onChanged: (value) {
                    if (value.startsWith("#") && viewModel.currentTab != SearchTab.tags) {
                      DefaultTabController.of(context)?.animateTo(SearchTab.tags.index);
                    }
                  },
                  controller: viewModel.searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: viewModel.searchIcon,
                    ),
                    suffixIcon: viewModel.search.isEmpty
                        ? null
                        : IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            onPressed: viewModel.clearSearch,
                            icon: const Icon(Icons.clear),
                          ),
                  ),
                ),
                bottom: TabBar(
                  onTap: viewModel.onTabChenged,
                  tabs: SearchTab.values.map((e) => Tab(text: e.name)).toList(),
                ),
              ),
            ],
            body: const TabBarView(
              children: [
                AllTabWidget(),
                TagTabWidget(),
                UserTabWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create({String searchText = ""}) => ChangeNotifierProvider<SearchViewModel>(
        lazy: false,
        create: (context) => SearchViewModel(context, searchText),
        child: const SearchWidget(),
      );
}
