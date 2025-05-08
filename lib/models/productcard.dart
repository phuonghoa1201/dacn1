import 'package:dacn1/models/rating.dart';

class Productcard {
  final String name;
  final String? image; // Thêm trường này
  final List<String>? images;
  final int price;
  final String? id;
  final List<Rating>? rating;

  Productcard({
    required this.name,
    this.image, // Thêm vào constructor
    this.images,
    required this.price,
    this.id,
    this.rating,
  });

  factory Productcard.fromMap(Map<String, dynamic> map) {
    return Productcard(
      name: map['name'] ?? '',
      image: map['image'], // Thêm dòng này
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      price: map['price']?.toInt() ?? 0,
      id: map['_id'],
      rating:
          map['ratings'] != null
              ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromMap(x)))
              : null,
    );
  }
}
