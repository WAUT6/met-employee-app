import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class ChatUser {
  final String id;
  final String aboutMe;
  final String profileImageUrl;
  final String nickname;

  const ChatUser({
    required this.id,
    required this.aboutMe,
    required this.profileImageUrl,
    required this.nickname,
  });

  ChatUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : aboutMe = snapshot.data()[FirestoreConstants.aboutMe] as String,
        profileImageUrl =
            snapshot.data()[FirestoreConstants.profileUrl] as String,
        nickname = snapshot.data()[FirestoreConstants.nickname] as String,
        id = snapshot.id;
}
