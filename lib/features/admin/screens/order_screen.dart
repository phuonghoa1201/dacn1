import 'package:dacn1/features/account/widgets/single_product.dart';
import 'package:dacn1/features/admin/services/admin_services.dart';
import 'package:dacn1/features/order_details/screens/order_details.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
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
              child: SizedBox(
                height: 140,
                child: SingleProduct(image: orderData.products[0].images[0]),
              ),
            );
          },
        );
  }
}
