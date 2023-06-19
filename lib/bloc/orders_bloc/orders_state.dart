part of 'orders_bloc.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersStateUpdatingOrderItemIsReady extends OrdersState {
  const OrdersStateUpdatingOrderItemIsReady();
}

class OrdersStateDeletingOrder extends OrdersState {
  const OrdersStateDeletingOrder();
}

class OrdersStateDeletingOrdersForTheDay extends OrdersState {
  const OrdersStateDeletingOrdersForTheDay();
}
