import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudOrder {
  final String date;
  final String documentId;
  final String orderId;
  final String customerId;
  final Stream<Iterable<CloudOrderItem>> items;

  CloudOrder({
    required this.date,
    required this.documentId,
    required this.orderId,
    required this.customerId,
    required this.items,
  });

  CloudOrder.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    this.items,
  )   : documentId = snapshot.id,
        date = snapshot.data()[FirestoreConstants.orderDate] as String,
        orderId =
            snapshot.data()[FirestoreConstants.orderNumberFieldName] as String,
        customerId = snapshot
            .data()[FirestoreConstants.orderCustomerNumberFieldName] as String;
}
