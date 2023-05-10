import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metapp/constants/routes.dart';

import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

import 'package:metapp/bloc/view_bloc/view_bloc.dart';

import 'package:metapp/views/order_views/orders_grid_view.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

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
    return BlocProvider<ViewBloc>(
      create: (context) => context.read<ViewBloc>(),
      child: Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       viewBloc.add(const ViewEventGoToHomePage());
        //     },
        //     icon: const Icon(Icons.home),
        //   ),
        //   title: const Text('Orders'),
        //   centerTitle: true,
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         Navigator.pushNamed(
        //           context,
        //           createNewOrderRoute,
        //         );
        //       },
        //       icon: const Icon(
        //         Icons.add,
        //       ),
        //     ),
        //     PopupMenuButton(
        //       itemBuilder: (context) {
        //         return [
        //           const PopupMenuItem(
        //             value: MenuAction.logout,
        //             child: Text('Log out'),
        //           )
        //         ];
        //       },
        //       onSelected: (value) async {
        //         switch (value) {
        //           case MenuAction.logout:
        //             final shouldLogout = await showLogOutDialog(context);
        //             if (shouldLogout) {
        //               viewBloc.add(
        //                 const ViewEventGoToHomePage(),
        //               );
        //               authBloc.add(
        //                 const AuthEventLogOut(),
        //               );
        //             }
        //             break;
        //           default:
        //             break;
        //         }
        //       },
        //     ),
        //   ],
        // ),
        body: StreamBuilder(
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
    );
  }
}
