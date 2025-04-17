import 'package:dacn1/contants/global_variables.dart';
import 'package:flutter/material.dart';

import 'package:dacn1/contants/global_variables.dart';
import 'package:flutter/material.dart';

import '../screens/category_deals_screen.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryDealsScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: GlobalVariables.categoryImages.length,
        scrollDirection: Axis.horizontal,
        itemExtent: screenWidth * 0.2, // Mỗi item chiếm 25% chiều rộng
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap:
                () =>
                    navigateToCategoryPage(
                      context,
                      GlobalVariables.categoryImages[index]['title']!,
                    ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        GlobalVariables.categoryImages[index]['image']!,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: Text(
                      GlobalVariables.categoryImages[index]['title']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
