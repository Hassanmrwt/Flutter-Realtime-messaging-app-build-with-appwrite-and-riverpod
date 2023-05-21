import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/login_view.dart';
import 'package:pmtc/providers.dart';
import 'package:pmtc/user_widget.dart';

class Home extends ConsumerStatefulWidget {
  final String loggedUserName;
  const Home({required this.loggedUserName, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final account = Account(client);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(widget.loggedUserName),
          IconButton(
              onPressed: () async {
                await account.deleteSession(sessionId: "current").then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                });
              },
              icon: const Icon(Icons.logout_rounded))
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Realtime Chat Appwrite'),
      ),
      body: const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child: AllUsers()),
    );
  }
}
