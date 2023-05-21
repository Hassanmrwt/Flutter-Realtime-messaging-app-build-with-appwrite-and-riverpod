import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/functions.dart';
import 'package:pmtc/models.dart';
import 'package:pmtc/providers.dart';
import 'package:pmtc/single_chat.dart';
import 'package:pmtc/user_card..dart';

class AllUsers extends ConsumerStatefulWidget {
  const AllUsers({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => All_UsersState();
}

class All_UsersState extends ConsumerState<AllUsers> {
  String? loggedUserEmail;
  String? loggedUserId;
  String? loggedUserName;
  @override
  void initState() {
    currentUserAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loggedUserName = ref.watch(currentUserAccountProvider).value!.name;
    loggedUserEmail = ref.watch(currentUserAccountProvider).value!.email;
    loggedUserId = ref.watch(currentUserAccountProvider).value!.$id;
    return ref.watch(getUserProvider).when(
        data: (users) {
          return ref.watch(realtimeUsersAndMessagesProvider).when(
                data: (latestUser) {
                  if (latestUser.events.contains(
                      'databases.chat.collections.usera.documents.*.create')) {
                    final newUser = OurUsers.fromMap(latestUser.payload);
                    if (users.contains(newUser)) {
                      // do nothing as it is already added
                    } else {
                      users.add(newUser);
                    }
                  }
                  if (latestUser.events.contains(
                      'databases.chat.collections.usera.documents.*.delete')) {
                    final deletedUser = OurUsers.fromMap(latestUser.payload);
                    if (users.contains(deletedUser)) {
                      users.remove(deletedUser);
                    }
                  }
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      if (user.email.toLowerCase() == loggedUserEmail) {
                        return const SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleChat(
                                        chatUserName: user.name,
                                        chatUserId: user.userId,
                                        loggedUserName: loggedUserName!,
                                        loggedUserId: loggedUserId!,
                                      )));
                        },
                        child: UserCard(
                          name: user.name,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () {
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      if (user.email.toLowerCase() == loggedUserEmail) {
                        return const SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleChat(
                                        chatUserName: user.name,
                                        chatUserId: user.userId,
                                        loggedUserName: loggedUserName!,
                                        loggedUserId: loggedUserId!,
                                      )));
                        },
                        child: UserCard(
                          name: user.name,
                        ),
                      );
                    },
                  );
                },
              );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
