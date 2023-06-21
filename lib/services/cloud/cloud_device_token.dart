import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudDeviceToken {
  final String token;
  final String userId;

  const CloudDeviceToken({required this.token, required this.userId,});

  CloudDeviceToken.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
      userId = snapshot.id,
      token = snapshot.data()[FirestoreConstants.tokenFieldName] as String;

}