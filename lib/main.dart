import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/home.dart';
import 'package:pmtc/login_view.dart';
import 'package:pmtc/providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realtime Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      home: ref.watch(currentUserAccountProvider).when(data: (user) {
        if (user != null) {
          return Home(
            loggedUserName: user.name,
          );
        } else {
          return const LoginView();
        }
      }, error: (error, st) {
        return null;
      }, loading: () {
        return null;
      }),
      // builder: EasyLoading.init(),
    );
  }
}
