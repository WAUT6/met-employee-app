import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class ChatProvider {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore cloudStorage = FirebaseFirestore.instance;

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
    String collectionPath,
    String documentPath,
    Map<String, dynamic> dataToUpdate,
  ) async {
    await cloudStorage
        .collection(collectionPath)
        .doc(documentPath)
        .update(dataToUpdate);
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
