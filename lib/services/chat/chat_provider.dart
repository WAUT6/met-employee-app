import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

class ChatProvider {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore cloudStorage = FirebaseFirestore.instance;
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();

  static final ChatProvider _shared = ChatProvider._sharedInstance();
  ChatProvider._sharedInstance();
  factory ChatProvider() => _shared;

  UploadTask uploadFile({required File image, required String fileName}) {
    return _cloudStorage.uploadFile(
      image,
      fileName,
    );
  }

  void sendMessage(
    String content,
    String idFrom,
    String idTo,
    String groupChatId,
    int contentType,
  ) {
    DocumentReference reference = cloudStorage
        .collection(FirestoreConstants.messagesCollectionPathName)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
    ChatMessage message = ChatMessage(
      idFrom: idFrom,
      idTo: idTo,
      content: content,
      contentType: contentType,
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    cloudStorage.runTransaction(
      (transaction) async {
        transaction.set(
          reference,
          message.messageToJson(),
        );
      },
    );
  }
}
