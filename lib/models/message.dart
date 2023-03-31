// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String request;
  String id;
  String lastMessage;
  String status;
  String patientId;
  String pharmacistId;
  num fontSize;
  Timestamp timestamp;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.status,
    required this.patientId,
    required this.pharmacistId,
    required this.request,
    required this.fontSize,
    required this.timestamp,
  });

  factory Chat.fromSnapshot(DocumentSnapshot snapshot) {
    return Chat(
      id: snapshot.id,
      lastMessage: snapshot['lastMessage'],
      status: snapshot['status'],
      patientId: snapshot['patientId'],
      pharmacistId: snapshot['pharmacistId'],
      request: snapshot['request'],
      fontSize: snapshot['fontSize'],
      timestamp: snapshot['timestamp'],
    );
  }
}

class ChatMessage {
  String message;
  String senderId;
  String type;
  Timestamp timestamp;

  ChatMessage({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.type,
  });

  ChatMessage.fromSnapshot(DocumentSnapshot snapshot)
      : message = snapshot['message'],
        senderId = snapshot['senderId'],
        timestamp = snapshot['timestamp'],
        type = snapshot['type'];

  Map<String, dynamic> toFirebase() {
    return <String, dynamic>{
      'message': message,
      'senderId': senderId,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
