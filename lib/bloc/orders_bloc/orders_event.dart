part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersEventDeleteOrder extends OrdersEvent {
  final CloudOrder order;

  const OrdersEventDeleteOrder({required this.order,});
}

class OrdersEventDeleteOrdersForTheDay extends OrdersEvent {
  const OrdersEventDeleteOrdersForTheDay();
}

class OrdersEventUpdateOrderItemIsReady extends OrdersEvent {
  final String orderId;
  final String documentId;
  final bool isReady;

  const OrdersEventUpdateOrderItemIsReady({required this.orderId, required this.documentId, required this.isReady,});
}
