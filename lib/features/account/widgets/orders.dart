import 'package:dacn1/common/widgets/loader.dart';
import 'package:dacn1/features/account/services/account_service.dart';
import 'package:dacn1/features/account/widgets/single_product.dart';
import 'package:dacn1/features/order_details/screens/order_details.dart';
import 'package:dacn1/models/order.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountService accountService = AccountService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountService.fetchMyOrder(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: const Text(
                    'Your Orders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 18,
                      color: GlobalVariables.selectedNavBarColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ), // khoảng cách giữa Row và Container sản phẩm
            Container(
              height: 170,
              padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailScreen.routeName,
                        arguments: orders![index],
                      );
                    },
                    child: SingleProduct(
                      image: orders![index].products[0].images[0],
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}
