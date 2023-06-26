import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/cloud/firebase/cloud_storage_constants.dart';

import 'cloud_order_item.dart';

class CloudOrder {
  final String date;
  final String documentId;
  final String customerId;
  final Stream<Iterable<CloudOrderItem>> items;
  final String employeeId;

  CloudOrder({
    required this.date,
    required this.documentId,
    required this.customerId,
    required this.items,
    required this.employeeId
  });

  CloudOrder.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    this.items,
  )   : documentId = snapshot.id,
        date = snapshot.data()[FirestoreConstants.orderDate] as String,
        customerId = snapshot
            .data()[FirestoreConstants.orderCustomerNumberFieldName] as String,
        employeeId = snapshot.data()[FirestoreConstants.orderEmployeeNameFieldName] as String;
}
