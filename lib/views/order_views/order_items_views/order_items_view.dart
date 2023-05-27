import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/io_bloc/io_bloc.dart';
import 'package:metapp/bloc/io_bloc/io_events.dart';
import 'package:metapp/constants/routes.dart';
import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/generics/get_arguments.dart';
import 'package:metapp/views/order_views/order_items_views/order_items_grid_view.dart';

class OrderItemsView extends StatefulWidget {
  const OrderItemsView({super.key});

  @override
  State<OrderItemsView> createState() => _OrderItemsViewState();
}

class _OrderItemsViewState extends State<OrderItemsView> {
  late final FirebaseCloudStorage _cloudStorage;
  late final String _orderId;
  Iterable<CloudOrderItem> allOrderItems = const Iterable.empty();

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderId = context.getArgument<CloudOrder>()!.documentId;
    return BlocProvider<IoBloc>(
      create: (context) => IoBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Order Items'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  createOrUpdateOrderItemRoute,
                  arguments: {
                    'orderId': _orderId,
                    'cloudOrderItem': null,
                  },
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
            IconButton(
              onPressed: () async {
                final orderCustomerName =
                    context.getArgument<CloudOrder>()!.customerId;
                BlocProvider.of<IoBloc>(context).add(
                  IoEventWantsToDownloadOrderAsPdf(
                    customerName: orderCustomerName,
                    items: allOrderItems,
                  ),
                );
              },
              icon: const Icon(Icons.download),
            ),
            IconButton(
              onPressed: () async {
                final orderCustomerName =
                    context.getArgument<CloudOrder>()!.customerId;
                BlocProvider.of<IoBloc>(context).add(
                  IoEventWantsToShareOrderAsPdf(
                    customerName: orderCustomerName,
                    items: allOrderItems,
                  ),
                );
                Navigator.pushNamed(
                  context,
                  selectUsersRoute,
                );
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: _cloudStorage.allOrderItems(orderId: _orderId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(
                      child: Text(
                        'No Items Yet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  allOrderItems = snapshot.data as Iterable<CloudOrderItem>;
                  return OrderItemsGridView(
                    orderItems: allOrderItems,
                    onTap: (item) {
                      Navigator.pushNamed(
                        context,
                        createOrUpdateOrderItemRoute,
                        arguments: {
                          'cloudOrderItem': item,
                          'orderId': _orderId,
                        },
                      );
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
    );
  }
}
