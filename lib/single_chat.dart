import 'package:appwrite/appwrite.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/constants.dart';
import 'package:pmtc/message_widget.dart';
import 'package:pmtc/providers.dart';

class SingleChat extends ConsumerStatefulWidget {
  final String chatUserName;
  final String chatUserId;
  final String loggedUserName;
  final String loggedUserId;
  const SingleChat(
      {required this.loggedUserId,
      required this.loggedUserName,
      required this.chatUserId,
      required this.chatUserName,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleChatState();
}

class _SingleChatState extends ConsumerState<SingleChat> {
  sentMessage(String message) async {
    final Databases db = Databases(client);
    try {
      await db.createDocument(
          databaseId: 'chat',
          collectionId: collectionID,
          documentId: ID.unique(),
          data: {"message": message, "messagedBy": widget.loggedUserName});
      scrollDown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${e.toString()}\n Please Try Again!")));
    }
  }

  String collectionID = '';
  checkChatroomIfEarlierCreated() async {
    final db = Databases(client);
    final function = Functions(client);
    try {
      final collectionName = widget.chatUserName + widget.loggedUserName;
      collectionID = collectionName;
      var res = await db.listDocuments(
          databaseId: "chat", collectionId: collectionID);
      if (res.total >= 0) {
        setState(() {
          ref.read(currentChatCollectionIdProvider.notifier).state =
              collectionID;
          isChatroomCreated = true;
        });
        scrollDown();
      }
    } on AppwriteException {
      try {
        final collectionName = widget.loggedUserName + widget.chatUserName;
        collectionID = collectionName;
        var res = await db.listDocuments(
            databaseId: "chat", collectionId: collectionID);
        if (res.total >= 0) {
          setState(() {
            ref.read(currentChatCollectionIdProvider.notifier).state =
                collectionID;
            isChatroomCreated = true;
          });
          scrollDown();
        }
      } on AppwriteException {
        final collectionName = widget.chatUserName + widget.loggedUserName;
        collectionID = collectionName;
        //2nd string
        final jsonData =
            '{"collectionName": "$collectionName","chatUserId": "${widget.chatUserId}","loggedUserId": "${widget.loggedUserId}"}';
        final execution = await function.createExecution(
            data: jsonData, functionId: "64622a412b86e19a27ac");
        if (execution.status == 'completed') {
          setState(() {
            ref.read(currentChatCollectionIdProvider.notifier).state =
                collectionName;
            isChatroomCreated = true;
          });
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Something went wrong, please try again')));
        }
      }
    }
  }

  var client;
  @override
  void initState() {
    client = Constants().myClient;
    checkChatroomIfEarlierCreated();
    scrollDown();
    super.initState();
  }

  final controller = ScrollController();
  scrollDown() async {
    await Future.delayed(const Duration(microseconds: 900));
    if (controller.hasClients) {
      print('animating to');
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(microseconds: 550),
          curve: Curves.elasticOut);
    }
  }

  bool isChatroomCreated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(widget.chatUserName),
      ),
      body: isChatroomCreated
          ? Stack(children: [
              SingleChildScrollView(
                controller: controller,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 45),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          child: MessageList(
                        chatUserName: widget.chatUserName,
                      )),
                    ],
                  ),
                ),
              ),
            ])
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 65,
          width: MediaQuery.of(context).size.width,
          child: MessageBar(
            onSend: (message) => (sentMessage(message)),
          ),
        ),
      ),
    );
  }
}
