import 'package:dacn1/common/widgets/loader.dart';
import 'package:dacn1/features/home/services/home_services.dart';
import 'package:dacn1/features/product_details/screens/product_detail_screen.dart';
import 'package:dacn1/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({Key? key}) : super(key: key);


  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}


class _FeaturedProductsState extends State<FeaturedProducts> {
  List<Product>? featuredProducts;
  final HomeServices homeServices = HomeServices();


  @override
  void initState() {
    super.initState();
    fetchFeaturedProducts();
  }


  void fetchFeaturedProducts() async {
    featuredProducts = await homeServices.fetchFeaturedProducts(context: context);
    setState(() {});
  }


  void navigateToDetailScreen(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }


  @override
  Widget build(BuildContext context) {
    return featuredProducts == null
        ? const Loader()
        : featuredProducts!.isEmpty
        ? const SizedBox()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 15),
          child: Text(
            'Sản phẩm nổi bật',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: featuredProducts!.length.clamp(0, 6), // Giới hạn 6 sản phẩm
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = featuredProducts![index];
            return GestureDetector(
              onTap: () => navigateToDetailScreen(product),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          product.images[0],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${NumberFormat('#,###').format(product.price)} VNĐ',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
