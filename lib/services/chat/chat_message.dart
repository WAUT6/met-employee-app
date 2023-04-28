import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/chat/chat_exceptions.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class ChatMessage {
  final String idFrom;
  final String idTo;
  final String content;
  final int contentType;
  final String timeStamp;

  ChatMessage({
    required this.idFrom,
    required this.idTo,
    required this.content,
    required this.contentType,
    required this.timeStamp,
  });

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    String idFrom = '';
    String idTo = '';
    String content = '';
    int contentType;
    String time = '';
    try {
      idFrom = doc.get(FirestoreConstants.idFrom);
      idTo = doc.get(FirestoreConstants.idTo);
      content = doc.get(FirestoreConstants.chatContent);
      contentType = doc.get(FirestoreConstants.chatType);
      time = doc.get(FirestoreConstants.time);
    } on StateError catch (_) {
      throw NoChatFoundChatException();
    }
    return ChatMessage(
      idFrom: idFrom,
      idTo: idTo,
      content: content,
      contentType: contentType,
      timeStamp: time,
    );
  }

  Map<String, dynamic> messageToJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.chatContent: content,
      FirestoreConstants.chatType: contentType,
      FirestoreConstants.time: timeStamp,
    };
  }
}
