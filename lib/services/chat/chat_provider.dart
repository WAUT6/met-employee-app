import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/cloud/firebase/cloud_storage_constants.dart';

import '../cloud/firebase/firebase_cloud_storage.dart';
import 'chat_user.dart';

class ChatProvider {
  final FirebaseFirestore _firestoreStorage = FirebaseFirestore.instance;
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();

  Future<ChatUser> currentChatUser({required String id}) async {
    return await _cloudStorage.getCurrentChatUser(id: id).first;
  }

  static final ChatProvider _shared = ChatProvider._sharedInstance();
  ChatProvider._sharedInstance();
  factory ChatProvider() => _shared;

  UploadTask uploadFile({required File file, required String fileName}) {
    return _cloudStorage.uploadFile(
      file,
      fileName,
    );
  }

  String setGroupId(String idFrom, String idTo) {
    if (idFrom.compareTo(idTo) > 0) {
      return '$idFrom-$idTo';
    } else {
      return '$idTo-$idFrom';
    }
  }

  void sendPdfAsMessages(
    String content,
    String idFrom,
    List<ChatUser> receivingUsers,
    int contentType,
  ) {
    for (var i = 0; i < receivingUsers.length; i++) {
      final String groupId = setGroupId(idFrom, receivingUsers[i].id);
      DocumentReference reference = _firestoreStorage
          .collection(FirestoreConstants.messagesCollectionPathName)
          .doc(groupId)
          .collection(groupId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      ChatMessage message = ChatMessage(
        idFrom: idFrom,
        idTo: receivingUsers[i].id,
        content: content,
        contentType: contentType,
        timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      _firestoreStorage.runTransaction(
        (transaction) async {
          transaction.set(
            reference,
            message.messageToJson(),
          );
        },
      );
    }
  }

  void sendMessage(
    String content,
    String idFrom,
    String idTo,
    String groupChatId,
    int contentType,
  ) {
    DocumentReference reference = _firestoreStorage
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

    _firestoreStorage.runTransaction(
      (transaction) async {
        transaction.set(
          reference,
          message.messageToJson(),
        );
      },
    );
  }

  Future<void> addUserToFavorites({
    required ChatUser user,
    required String currentUserId,
  }) async {
    await _cloudStorage.addUserToFavoriteUsers(
        currentUserId: currentUserId, user: user);
  }

  Future<void> removeUserFromFavorites({
    required ChatUser user,
    required String currentUserId,
  }) async {
    _cloudStorage.removeUserFromFavoriteUsers(
        currentUserId: currentUserId, user: user);
  }
}
