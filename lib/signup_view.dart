import 'package:appwrite/appwrite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/constants.dart';
import 'package:pmtc/providers.dart';
import 'login_view.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  @override
  void dispose() {
    super.dispose();
  }

  void onSignUp() async {
    final name = ref.watch(emailProvider).split("@").first;
    try {
      final res = await account.create(
          userId: ID.unique(),
          name: name,
          email: ref.watch(emailProvider),
          password: ref.watch(passwordProvider));
      await db.createDocument(
          databaseId: "chat",
          collectionId: "usera",
          documentId: ID.unique(),
          data: {
            'name': name,
            'email': ref.watch(emailProvider),
            'userId': res.$id
          }).then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      });
    } catch (e) {
      setState(() {
        isPressed = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${e.toString()}\n Please Try Again")));
    }
  }

  final Client client = Constants().myClient;
  var db;
  var account;
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    db = Databases(client);
    account = Account(client);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextFormField(
                  initialValue: ref.read(emailProvider.notifier).state,
                  onChanged: (value) =>
                      ref.read(emailProvider.notifier).state = value,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.all(22),
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  initialValue: ref.read(passwordProvider.notifier).state,
                  onChanged: (value) =>
                      ref.read(passwordProvider.notifier).state = value,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.all(22),
                    hintText: "Password",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      onSignUp();
                      setState(() {
                        isPressed = true;
                      });
                    },
                    child: Chip(
                      label: isPressed
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: ' Login',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              LoginView.route(),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
