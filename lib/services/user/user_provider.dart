import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class UserProvider {
  final FirebaseFirestore cloudStorage = FirebaseFirestore.instance;

  Future<void> updateFirestoreData(
    String collectionPath,
    String documentPath,
    Map<String, dynamic> dataToUpdate,
  ) {
    return cloudStorage
        .collection(collectionPath)
        .doc(documentPath)
        .update(dataToUpdate);
  }

  Stream<Iterable<ChatUser>> getFirestoreStream(
    String collectionPath,
    int limit,
    String? search,
  ) {
    if (search != null) {
      return cloudStorage
          .collection(collectionPath)
          .limit(limit)
          .where(
            FirestoreConstants.nickname,
            isEqualTo: search,
          )
          .snapshots()
          .map(
            (event) => event.docs.map(
              (doc) => ChatUser.fromSnapshot(doc),
            ),
          );
    } else {
      return cloudStorage
          .collection(collectionPath)
          .limit(limit)
          .snapshots()
          .map(
            (event) => event.docs.map(
              (doc) => ChatUser.fromSnapshot(doc),
            ),
          );
    }
  }
}
