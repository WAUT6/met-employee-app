import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metapp/constants/routes.dart';

import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

import 'package:metapp/bloc/view_bloc/view_bloc.dart';

import 'package:metapp/views/order_views/orders_grid_view.dart';

import '../../bloc/orders_bloc/orders_bloc.dart';
import '../../utilities/dialogs/deletion_confirmation_dialog.dart';

class OrdersView extends StatefulWidget {
  static const OrdersView _shared = OrdersView._sharedInstance();
  const OrdersView._sharedInstance();
  factory OrdersView() => _shared;
  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersBloc = context.read<OrdersBloc>();
    return BlocProvider<ViewBloc>(
      create: (context) => context.read<ViewBloc>(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                final response = await showDeletionConfirmationDialog(context);
                if(response) {
                  ordersBloc.add(const OrdersEventDeleteOrdersForTheDay());
                }
              },
              icon: const Icon(Icons.pin_end_outlined, color: Colors.black,),
            ),
            title: const Text(
              'Orders',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            elevation: 0.3,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    createNewOrderRoute,
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5,),
            padding: const EdgeInsets.all(5),
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: StreamBuilder(
                stream: _cloudStorage.allOrders(50),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (!snapshot.hasData) {
                        return const Scaffold(
                          body: Center(
                            child: Text(
                              'No orders yet',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        final allOrders = snapshot.data as Iterable<CloudOrder>;
                        return OrdersGridView(
                          orders: allOrders,
                          onDelete: (order) {
                            ordersBloc.add(OrdersEventDeleteOrder(order: order));
                          },
                          onTap: (order) {
                            Navigator.pushNamed(context, viewOrderItemsRoute,
                                arguments: order);
                          },
                        );
                      }
                    default:
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
