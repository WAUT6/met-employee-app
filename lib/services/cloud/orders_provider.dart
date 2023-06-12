import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

class OrdersProvider {
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();

  Future<void> updateOrderItemIsReady({required bool isReady, required String orderId, required String documentId,}) async {
    await _cloudStorage.updateOrderItemIsReady(orderId: orderId, documentId: documentId, isReady: isReady,);
  }
}