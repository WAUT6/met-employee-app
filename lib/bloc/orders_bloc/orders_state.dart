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
