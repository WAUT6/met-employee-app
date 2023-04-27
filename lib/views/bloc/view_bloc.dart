import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/views/bloc/view_events.dart';
import 'package:metapp/views/bloc/view_states.dart';

class ViewBloc extends Bloc<ViewEvent, ViewState> {
  ViewBloc()
      : super(
          const ViewStateViewingHomePage(),
        ) {
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
  }
}
