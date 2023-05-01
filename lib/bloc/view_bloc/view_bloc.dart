import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/view_bloc/view_events.dart';
import 'package:metapp/bloc/view_bloc/view_states.dart';

class ViewBloc extends Bloc<ViewEvent, ViewState> {
  ViewBloc()
      : super(
          const ViewStateViewingHomePage(),
        ) {
    on<ViewEventGoToChats>(
      (event, emit) {
        emit(const ViewStateViewingChats());
      },
    );

    on<ViewEventGoToHomePage>(
      (event, emit) {
        emit(
          const ViewStateViewingHomePage(),
        );
      },
    );

    on<ViewEventGoToItems>(
      (event, emit) {
        emit(
          const ViewStateViewingItems(),
        );
      },
    );

    on<ViewEventGoToOrders>(
      (event, emit) {
        emit(
          const ViewStateViewingOrders(),
        );
      },
    );

    on<ViewEventCreateNewOrder>(
      (event, emit) {
        emit(
          const ViewStateCreatingNewOrder(),
        );
      },
    );
  }
}
