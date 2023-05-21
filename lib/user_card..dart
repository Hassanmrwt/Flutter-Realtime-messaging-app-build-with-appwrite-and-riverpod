import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name; // new code
  UserCard({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.greenAccent),
      child: ListTile(
        title: Text(name),
        trailing: const Icon(Icons.message),
      ),
    );
  }
}
