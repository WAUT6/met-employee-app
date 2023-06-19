import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

class OrdersProvider {
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();

  Future<void> updateOrderItemIsReady({required bool isReady, required String orderId, required String documentId,}) async {
    await _cloudStorage.updateOrderItemIsReady(orderId: orderId, documentId: documentId, isReady: isReady,);
  }

  Future<void> deleteOrder({required CloudOrder order,}) async {
    await _cloudStorage.deleteOrder(documentId: order.documentId);
  }

  Future<void> deleteAllOrders() async {
    await _cloudStorage.deleteAllOrders();
  }

}