import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase/cloud_category.dart';
import 'firebase/cloud_storage_constants.dart';

class CloudCategoryItem {
  final String documentId;
  final String itemName;
  final String itemPrice;
  final CloudCategory category;

  CloudCategoryItem({required this.documentId, required this.itemName, required this.itemPrice, required this.category,});

  CloudCategoryItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, this.category,) :
      documentId = snapshot.id,
      itemName = snapshot.data()[FirestoreConstants.itemNameFieldName],
      itemPrice = snapshot.data()[FirestoreConstants.itemPriceFieldName];
}