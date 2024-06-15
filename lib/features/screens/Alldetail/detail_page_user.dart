import 'package:flutter/material.dart';
import 'package:task/models/user_model.dart';

class AllDetailPage extends StatelessWidget {
  final Data user;

  const AllDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.picture != null ? NetworkImage(user.picture!) : null,
                child: user.picture == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Text('Title: ${user.title ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('First Name: ${user.firstName ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('Last Name: ${user.lastName ?? 'N/A'}'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
