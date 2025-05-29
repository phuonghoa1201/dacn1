import 'package:dacn1/common/widgets/loader.dart';
import 'package:dacn1/features/home/services/home_services.dart';
import 'package:dacn1/features/product_details/screens/product_detail_screen.dart';
import 'package:dacn1/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) return const Loader();
    if (product!.name.isEmpty) return const SizedBox();

    return GestureDetector(
      onTap: navigateToDetailScreen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal sốc',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product!.images[0],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${NumberFormat('#,###').format(product!.price)} VNĐ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  product!.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: product!.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product!.images[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'See all deals',
                  style: TextStyle(
                    color: Colors.cyan[800],
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
