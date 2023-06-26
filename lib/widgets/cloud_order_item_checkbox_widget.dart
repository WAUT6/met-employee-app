import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/orders_bloc/orders_bloc.dart';
import 'package:metapp/services/cloud/orders_provider.dart';

import '../services/cloud/firebase/cloud_order_item.dart';


class CloudOrderCheckBox extends StatefulWidget {
  final CloudOrderItem item;
  final String orderId;
  const CloudOrderCheckBox({super.key, required this.item, required this.orderId,});

  @override
  State<CloudOrderCheckBox> createState() => _CloudOrderCheckBoxState();

}

class _CloudOrderCheckBoxState extends State<CloudOrderCheckBox> {
  late bool _isSelected;

  @override
  initState() {
    setState(() {
      _isSelected = widget.item.isReady;
    });

    super.initState();


}




  _handleSelected(BuildContext context) {
    if (_isSelected) {
      context.read<OrdersBloc>().add(OrdersEventUpdateOrderItemIsReady(orderId: widget.orderId, documentId: widget.item.id, isReady: false,));
      setState(() {
        _isSelected = false;
      });
    } else {
      context.read<OrdersBloc>().add(OrdersEventUpdateOrderItemIsReady(orderId: widget.orderId, documentId: widget.item.id, isReady: true,));
      setState(() {
        _isSelected = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => OrdersBloc(OrdersProvider()),
      child:
        IconButton(
        onPressed: () => _handleSelected(context),
    icon: _isSelected
    ? const Image(
    image: AssetImage('assets/images/green-check-box.png'),
    )
        : const Image(
    image: AssetImage('assets/images/check-box.png'),
    ),
    ),
    );
  }
}


