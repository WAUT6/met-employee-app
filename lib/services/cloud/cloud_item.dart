import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudItem {
  final String documentId;
  final String name;
  final String price;

  CloudItem({
    required this.documentId,
    required this.name,
    required this.price,
  });

  CloudItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[itemNameFieldName] as String,
        price = snapshot.data()[itemPriceFieldName] as String;
}
