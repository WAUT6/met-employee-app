
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/cloud/orders_provider.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(OrdersProvider provider) : super(const OrdersInitial()) {
    on<OrdersEventUpdateOrderItemIsReady>((event, emit) async {
      emit(const OrdersStateUpdatingOrderItemIsReady());
      try {
        await provider.updateOrderItemIsReady(isReady: event.isReady, orderId: event.orderId, documentId: event.documentId,);
        emit(const OrdersInitial());
      } catch (e) {
        Fluttertoast.showToast(msg: 'Could not update.');
      }
    });
  }
}
