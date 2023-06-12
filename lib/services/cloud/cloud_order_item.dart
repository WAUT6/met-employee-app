import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudOrderItem {
  final String id;
  final String itemName;
  final String packaging;
  final String quantity;
  final bool isReady;

  const CloudOrderItem({
    required this.isReady,
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
                as String,
        isReady = snapshot.data()[FirestoreConstants.orderItemsIsReadyFieldName] as bool;

  Map<String, dynamic> orderItemToJson() {
    return {
      FirestoreConstants.orderItemsItemNameFieldName: itemName,
      FirestoreConstants.orderItemsItemQuantityFieldName: quantity,
      FirestoreConstants.orderItemsPackagingFieldName: packaging,
      FirestoreConstants.orderItemsIsReadyFieldName: isReady,
    };
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return id;
      case 1:
        return itemName;
      case 2:
        return packaging;
      case 3:
        return quantity;
    }
    return '';
  }
}
