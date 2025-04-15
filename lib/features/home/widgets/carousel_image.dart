import 'package:dacn1/contants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CarouselSlider(
      items: GlobalVariables.carouselImages.map(
            (i) {
          return Builder(
            builder: (BuildContext context) => Container(
              width: screenWidth,
              child: Image.network(
                i,
                fit: BoxFit.cover,
                height: screenHeight * 0.25, // 25% chiều cao màn hình
              ),
            ),
          );
        },
      ).toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        height: screenHeight * 0.25, // đồng bộ với chiều cao ảnh
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
      ),
    );
  }
}