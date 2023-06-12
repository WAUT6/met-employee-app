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
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.3,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
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
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              footer: Text(
                order.orderId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    order.customerId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
