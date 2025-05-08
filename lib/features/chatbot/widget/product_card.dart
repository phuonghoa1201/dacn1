import 'package:dacn1/models/productcard.dart';
import 'package:dacn1/models/rating.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Productcard product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy URL ảnh - sửa lại theo đúng trường API trả về
    final imageUrl =
        product.image ??
        (product.images?.isNotEmpty == true ? product.images!.first : null);
    debugPrint('Product Image URL: $imageUrl');

    // Tính rating trung bình nếu có
    final averageRating =
        product.rating != null && product.rating!.isNotEmpty
            ? _calculateAverageRating(product.rating!)
            : null;

    return SizedBox(
      width: 160,
      height: 210,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            // Phần hình ảnh
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Image load error: $error');
                          return const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          );
                        },
                      )
                      : const Center(child: Icon(Icons.image, size: 40)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price} VND',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Hiển thị rating nếu có
                  if (averageRating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          averageRating,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          ' (${product.rating!.length})', // Hiển thị số lượng đánh giá
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Hiển thị khi không có rating
                    const SizedBox(height: 4),
                    const Text(
                      'Chưa có đánh giá',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverageRating(List<Rating> ratings) {
    final average =
        ratings.map((r) => r.rating).reduce((a, b) => a + b) / ratings.length;
    return average.toStringAsFixed(1);
  }
}
