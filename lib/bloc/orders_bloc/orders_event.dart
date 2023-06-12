part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersEventUpdateOrderItemIsReady extends OrdersEvent {
  final String orderId;
  final String documentId;
  final bool isReady;

  const OrdersEventUpdateOrderItemIsReady({required this.orderId, required this.documentId, required this.isReady,});
}
