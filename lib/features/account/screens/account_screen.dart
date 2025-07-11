import 'package:dacn1/features/account/widgets/below_app_bar.dart';
import 'package:dacn1/features/account/widgets/orders.dart';
import 'package:dacn1/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/Tech_Zone.png',
                  width: MediaQuery.of(context).size.width * 0.4,  // 40% chiều rộng màn hình
                  height: MediaQuery.of(context).size.height * 0.2, // 10% chiều cao màn hình
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(
                      Icons.search,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20),
          Orders(),
        ],
      ),
    );
  }
}