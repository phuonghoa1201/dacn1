import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dacn1/common/widgets/custom_button.dart';
import 'package:dacn1/common/widgets/start.dart';
import 'package:dacn1/contants/global_variables.dart';
import 'package:dacn1/features/product_details/services/product_detail_services.dart';
import 'package:dacn1/models/product.dart';
import 'package:dacn1/providers/user_providers.dart';
import 'package:dacn1/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  //   import class product
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices pds = ProductDetailsServices();
  double avgRating = 0.0;
  double myRating = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double totalRating = 0.0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchSreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    pds.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchSreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              size: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(top: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Electronic Store',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.mic, size: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(widget.product.id!), Stars(rating: avgRating)],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(widget.product.name, style: TextStyle(fontSize: 15)),
            ),
            CarouselSlider(
              items:
                  widget.product.images.map((i) {
                    return Builder(
                      builder:
                          (BuildContext context) => Image.network(
                            i,
                            fit: BoxFit.contain,
                            height: 200,
                          ),
                    );
                  }).toList(),
              options: CarouselOptions(viewportFraction: 1, height: 300),
            ),
            Container(color: Colors.black12, height: 5),
            Padding(
              padding: EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(color: Colors.black12, height: 5),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(text: 'Buy Now', onTap: () {}),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: 'Add to Cart',
                onTap: addToCart,
                color: Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            SizedBox(height: 10),
            Container(color: Colors.black12, height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Rate The Product',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) =>
                      Icon(Icons.star, color: GlobalVariables.secondaryColor),
              onRatingUpdate: (rating) {
                pds.rateProduct(
                  context: context,
                  product: widget.product,
                  rating: rating,
                );
                print(rating);
              },
            ),
          ],
        ),
      ),
    );
  }
}
