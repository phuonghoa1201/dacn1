import 'package:dacn1/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  // temporary list
  List list = [
    'https://img.global.news.samsung.com/vn/wp-content/uploads/2022/01/Galaxy-S21-FE-Color-Combo-KV_2P_ngang.jpg',
    'https://img.global.news.samsung.com/vn/wp-content/uploads/2022/01/Galaxy-S21-FE-Color-Combo-KV_2P_ngang.jpg',
    'https://img.global.news.samsung.com/vn/wp-content/uploads/2022/01/Galaxy-S21-FE-Color-Combo-KV_2P_ngang.jpg',
    'https://img.global.news.samsung.com/vn/wp-content/uploads/2022/01/Galaxy-S21-FE-Color-Combo-KV_2P_ngang.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 10), // khoảng cách giữa Row và Container sản phẩm
        Container(
          height: 170,
          padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
          child:
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,itemBuilder: (context, index){
              return SingleProduct(image: list[index],
              );
            },),
        ),
      ],
    );
  }
}
