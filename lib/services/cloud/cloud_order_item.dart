import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudOrderItem {
  final String id;
  final String itemName;
  final String packaging;
  final String quantity;

  const CloudOrderItem({
    required this.id,
    required this.itemName,
    required this.packaging,
    required this.quantity,
  });

  CloudOrderItem.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : id = snapshot.id,
        itemName = snapshot
            .data()[FirestoreConstants.orderItemsItemNameFieldName] as String,
        packaging = snapshot
            .data()[FirestoreConstants.orderItemsPackagingFieldName] as String,
        quantity =
            snapshot.data()[FirestoreConstants.orderItemsItemQuantityFieldName]
                as String;
}
