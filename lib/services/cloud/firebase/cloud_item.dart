import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/firebase/cloud_storage_constants.dart';

import '../firebase/cloud_category.dart';

class CloudItem {
  final String documentId;
  final String name;
  final String price;
  // final CloudCategory category;

  CloudItem({
    // required this.category,
    required this.documentId,
    required this.name,
    required this.price,
  });

  CloudItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot,)
      : documentId = snapshot.id,
        name = snapshot.data()[FirestoreConstants.itemNameFieldName] as String,
        price =
            snapshot.data()[FirestoreConstants.itemPriceFieldName] as String;
}
