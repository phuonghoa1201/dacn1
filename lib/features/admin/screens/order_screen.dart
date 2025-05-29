
import 'package:dacn1/features/account/widgets/single_product.dart';
import 'package:dacn1/features/admin/services/admin_services.dart';
import 'package:dacn1/features/order_details/screens/order_details.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../../../contants/utils.dart';
import '../../../models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  fetchOrder() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
          itemCount: orders!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
          ),
          itemBuilder: (context, index) {
            final orderData = orders![index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  OrderDetailScreen.routeName,
                  arguments: orderData,
                );
              },
              child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      orderData.products[0].images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              capitalize(orderData.user.name),
            style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
            '${formatDate(DateTime.fromMillisecondsSinceEpoch(orderData.orderedAt))}',
            style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            ),
            ),
            ],
            ),
            ),
                ],
              ),
              ),
            );
          },
        );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }


}




