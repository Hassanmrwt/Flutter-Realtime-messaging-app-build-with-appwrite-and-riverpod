import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmtc/constants.dart';
import 'package:pmtc/functions.dart';
import 'package:pmtc/models.dart';

final client = Constants().myClient;
final realtimeProvider = Provider<Realtime>((ref) {
  final realtime = Realtime(client);
  return realtime;
});

final emailProvider = StateProvider<String>((ref) => '@g.com');
final passwordProvider = StateProvider<String>((ref) => '12121212');

final currentChatCollectionIdProvider = StateProvider((ref) {
  return '';
});
final realtimeUsersAndMessagesProvider = StreamProvider<RealtimeMessage>((ref) {
  return ref.watch(realtimeProvider).subscribe(['documents']).stream;
});
final getMessagesProvider =
    FutureProvider.family<List<Message>, String>((ref, id) async {
  print(id);
  final messageList = await getMessages(currentChatId: id);
  return messageList;
});
final getUserProvider = FutureProvider((ref) {
  final usersList = getUsers();
  return usersList;
});
final currentUserAccountProvider = FutureProvider((ref) async {
  return await currentUserAccount();
});
