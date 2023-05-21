import 'package:appwrite/appwrite.dart';

class Constants {
  Client client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
      .setProject('645923b923fc4fbfee9b'); // Your project ID
  get myClient {
    return client;
  }
}
