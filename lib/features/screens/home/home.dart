import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/common/connectivity_service.dart';
import 'package:task/common/error_widget.dart';
import 'package:task/features/screens/home/common_listview_widget.dart';
import 'package:task/features/screens/home/usergridItem.dart';
import 'package:task/features/screens/services/user_services.dart';
import 'package:task/models/user_model.dart';
import 'package:task/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Data>? _filteredUserList;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    getUserData(context, page: currentPage, limit: usersPerPage);
    _searchController.addListener(_filterUsers);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    getUserData(context, page: currentPage, limit: usersPerPage);
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      currentPage++;
      getUserData(context, page: currentPage, limit: usersPerPage).then((_) {
        log('currentPage' + '$currentPage');
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userList = userProvider.user?.data;

    if (query.isEmpty) {
      setState(() {
        _filteredUserList = null;
      });
    } else {
      setState(() {
        _filteredUserList = userList
            ?.where((user) =>
                user.firstName?.toLowerCase().contains(query) ??
                false || user.lastName!.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredUserList = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatus = Provider.of<ConnectivityService>(context).status;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              AppBar(
                backgroundColor: Colors.white,
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search username...',
                      border: InputBorder.none,
                      suffixIcon: _searchController.text.isEmpty
                          ? const Icon(Icons.search)
                          : IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.cancel),
                            ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                    icon: Icon(
                        color: Colors.blue,
                        _isGridView ? Icons.list : Icons.grid_view),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Center(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (connectivityStatus == ConnectivityStatus.Offline) {
                return ErrorWidgetnet(
                  message: 'No internet connections',
                  onRetry: () async {
                    getUserData(context,
                        page: currentPage, limit: usersPerPage);
                  },
                );
              }
              if (userProvider.user == null) {
                return const CircularProgressIndicator();
              } else {
                final userList = userProvider.user!.data;
                return _isGridView
                    ? Stack(children: [
                        UserGridItem(
                          userList: userList ?? [],
                          filteredUserList: _filteredUserList,
                          clearSearchCallback: _clearSearch,
                          scrollController: _scrollController,
                        ),
                        if (_isLoadingMore)
                          Positioned(
                            bottom: 10,
                            left: MediaQuery.of(context).size.width / 2 - 15,
                            child: const CircularProgressIndicator(),
                          ),
                      ])
                    : Stack(
                        children: [
                          UserListView(
                            userList: userList ?? [],
                            filteredUserList: _filteredUserList,
                            clearSearchCallback: _clearSearch,
                            scrollController: _scrollController,
                          ),
                          if (_isLoadingMore)
                            Positioned(
                              bottom: 10,
                              left: MediaQuery.of(context).size.width / 2 - 15,
                              child: const CircularProgressIndicator(),
                            ),
                        ],
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
