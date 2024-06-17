import 'package:flutter/material.dart';
import 'package:task/features/screens/Alldetail/detail_page_user.dart';
import 'package:task/models/user_model.dart';

class UserGridItem extends StatelessWidget {
  final List<Data> userList;
  final List<Data>? filteredUserList;
  final VoidCallback clearSearchCallback;
  final ScrollController scrollController;

  const UserGridItem({
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
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust the number of columns as needed
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            controller: scrollController,
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final user = displayList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllDetailPage(user: user),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user.picture != null
                            ? NetworkImage(user.picture!)
                            : null,
                        child: user.picture == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
