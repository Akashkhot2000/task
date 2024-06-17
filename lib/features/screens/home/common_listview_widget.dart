import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:task/features/screens/Alldetail/detail_page_user.dart';
import 'package:task/models/user_model.dart';

class UserListView extends StatelessWidget {
  final List<Data> userList;
  final List<Data>? filteredUserList;
  final VoidCallback clearSearchCallback;
  final ScrollController scrollController;

  const UserListView({
    Key? key,
    required this.userList,
    required this.filteredUserList,
    required this.clearSearchCallback,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayList = filteredUserList ?? userList;

    return displayList.isEmpty
        ? const Center(child: Text('No users found'))
        : AnimationLimiter(
            child: ListView.builder(
              controller: scrollController,
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final user = displayList[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.withOpacity(0.2),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: user.picture != null
                                  ? NetworkImage(user.picture!)
                                  : null,
                              child: user.picture == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(user.title ?? ''),
                            subtitle:
                                Text('${user.firstName} ${user.lastName}'),
                            trailing: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AllDetailPage(user: user),
                                    ),
                                  );
                                },
                                child: const Icon(
                                    color: Colors.blue,
                                    Icons.arrow_circle_right_outlined)),
                            onTap: () {
                              // Handle tap event if necessary
                              print('ListTile tapped: ${user.firstName}');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
