import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/message_card.dart';
import 'package:pmtc/models.dart';
import 'package:pmtc/popup.dart';
import 'package:pmtc/providers.dart';

class MessageList extends ConsumerWidget {
  final String chatUserName;
  MessageList({required this.chatUserName, super.key});
  Databases db = Databases(client);
  deleteMessage(
      {required BuildContext context,
      required String colId,
      required String docId}) async {
    await db
        .deleteDocument(
            databaseId: 'chat', collectionId: colId, documentId: docId)
        .whenComplete(() => Navigator.pop(context));
  }

  final controller = ScrollController();
  onNewMessage() {
    if (controller.hasClients) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colId = ref.watch(currentChatCollectionIdProvider);
    return ref.watch(getMessagesProvider(colId)).when(
        data: (messages) {
          return ref.watch(realtimeUsersAndMessagesProvider).when(
                data: (latestMessage) {
                  if (latestMessage.events.contains(
                      'databases.chat.collections.$colId.documents.*.create')) {
                    final newMessage = Message.fromMap(latestMessage.payload);
                    if (messages.contains(newMessage)) {
                      //don't add then
                    } else {
                      messages.add(newMessage);
                    }
                  }
                  if (latestMessage.events.contains(
                      'databases.chat.collections.$colId.documents.*.delete')) {
                    final deletedMessage =
                        Message.fromMap(latestMessage.payload);
                    if (messages.contains(deletedMessage)) {
                      messages.remove(deletedMessage);
                    }
                  }
                  return ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      if (message.messagedBy != chatUserName) {
                        return GestureDetector(
                          onTap: () {
                            myPopup(
                                onConfirm: () => deleteMessage(
                                    context: context,
                                    colId: colId,
                                    docId: message.messageId),
                                message: message,
                                context: context);
                          },
                          child: MessageCard(
                            message: message,
                            isSender: true,
                          ),
                        );
                      } else {
                        return MessageCard(
                          message: message,
                          isSender: false,
                        );
                      }
                    },
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () {
                  return ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      if (message.messagedBy == chatUserName) {
                        return GestureDetector(
                          onTap: () {
                            myPopup(
                                onConfirm: () => deleteMessage(
                                    context: context,
                                    colId: colId,
                                    docId: message.messageId),
                                message: message,
                                context: context);
                          },
                          child: MessageCard(
                            message: message,
                            isSender: true,
                          ),
                        );
                      } else {
                        return MessageCard(
                          message: message,
                          isSender: false,
                        );
                      }
                    },
                  );
                },
              );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: Text('Getting your Messages')));
  }
}
