// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OurUsers {
  final String name;
  final String email;
  final String userId;
  OurUsers({
    required this.name,
    required this.email,
    required this.userId,
  });

  OurUsers copyWith({
    String? name,
    String? email,
    String? userId,
  }) {
    return OurUsers(
      name: name ?? this.name,
      email: email ?? this.email,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'userId': userId,
    };
  }

  factory OurUsers.fromMap(Map<String, dynamic> map) {
    return OurUsers(
      name: map['name'] as String,
      email: map['email'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OurUsers.fromJson(String source) =>
      OurUsers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OurUsers(name: $name, email: $email, userId: $userId)';

  @override
  bool operator ==(covariant OurUsers other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.userId == userId;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ userId.hashCode;
}

class Message {
  final String message;
  final String messagedBy;
  final String messageId;
  Message({
    required this.message,
    required this.messagedBy,
    required this.messageId,
  });

  Message copyWith({
    String? message,
    String? messagedBy,
    String? messageId,
  }) {
    return Message(
      message: message ?? this.message,
      messagedBy: messagedBy ?? this.messagedBy,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messagedBy': messagedBy,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      messagedBy: map['messagedBy'] as String,
      messageId: map['\$id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Message(message: $message, messagedBy: $messagedBy, messageId: $messageId)';

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.messagedBy == messagedBy &&
        other.messageId == messageId;
  }

  @override
  int get hashCode =>
      message.hashCode ^ messagedBy.hashCode ^ messageId.hashCode;
}
