import 'package:flutter/material.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';

typedef OnTapCallBack = void Function(CloudOrderItem);

class OrderItemsGridView extends StatelessWidget {
  final Iterable<CloudOrderItem> orderItems;
  final OnTapCallBack onTap;
  const OrderItemsGridView({
    super.key,
    required this.orderItems,
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
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = orderItems.elementAt(index);
        return InkWell(
          onTap: () => onTap(orderItem),
          child: GridTile(
            header: Text(
              "Quantity: ${orderItem.quantity}",
              textAlign: TextAlign.center,
            ),
            footer: Text(
              "Packaging: ${orderItem.packaging}",
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
                  orderItem.itemName,
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
