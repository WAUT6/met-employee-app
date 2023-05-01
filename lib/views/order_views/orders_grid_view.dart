import 'package:flutter/material.dart';
import 'package:metapp/services/cloud/cloud_order.dart';

typedef OnTapCallBack = void Function(CloudOrder);

class OrdersGridView extends StatelessWidget {
  final Iterable<CloudOrder> orders;
  final OnTapCallBack onTap;
  const OrdersGridView({
    super.key,
    required this.orders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders.elementAt(index);
        return InkWell(
          onTap: () => onTap(order),
          child: GridTile(
            header: Text(
              order.date,
              textAlign: TextAlign.center,
            ),
            footer: Text(
              order.orderId,
              textAlign: TextAlign.center,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  order.customerId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
