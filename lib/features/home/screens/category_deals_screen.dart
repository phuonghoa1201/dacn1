import 'package:dacn1/features/home/services/home_services.dart';
import 'package:dacn1/features/product_details/screens/product_detail_screen.dart';
import 'package:dacn1/models/product.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../../../contants/global_variables.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  late Color categoryColor;
  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
    categoryColor = getColorForCategory(widget.category);
  }

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
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body:
          productList == null
              ? const Loader()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_bag, color: categoryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Popular choices in ${widget.category}',
                            style: TextStyle(
                              fontSize: 20,
                              color: categoryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: productList!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 cột
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 3, // Tùy chỉnh để vừa khung hình
                      ),
                      itemBuilder: (context, index) {
                        final product = productList![index];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: product,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    // color: categoryColor,
                                    border: Border.all(color: categoryColor, width: 0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(product.images[0], fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${product.price}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
    );
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  Color getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'mobiles':
        return const Color(0xFFB39D00); // Màu vàng đậm
      case 'headsets':
        return const Color(0xFF880E4F); // Hồng đậm
      case 'keyboards':
        return const Color(0xFFF57F17); // Vàng đậm
      case 'speakers':
        return const Color(0xFF388E3C); // Xanh lá đậm
      case 'microphones':
        return const Color(0xFFF57F17); // Vàng đậm
      case 'mouse':
        return const Color(0xFF7B1FA2); // Tím đậm
      case 'watches':
        return const Color(0xFFFB8C00); // Cam đậm
      case 'laptops':
        return const Color(0xFF00796B); // Ngọc đậm
      case 'tablets':
        return const Color(0xFFF57F17); // Vàng đậm
      case 'ipads':
        return const Color(0xFF880E4F); // Hồng đậm
      default:
        return const Color(0xFF616161); // Màu xám đậm cho mặc định
    }
  }

}
