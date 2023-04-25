import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class CloudOrder {
  final String documentId;
  final String orderId;
  final String customerId;
  final List<Map<String, String>> items;

  CloudOrder({
    required this.documentId,
    required this.orderId,
    required this.customerId,
    required this.items,
  });

  CloudOrder.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        orderId = snapshot.data()[orderNumberFieldName] as String,
        customerId = snapshot.data()[orderCustomerNumberFieldName] as String,
        items = (snapshot.data()['order_items'] as List<Map<String, String>>);
}
