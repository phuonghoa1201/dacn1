// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dacn1/contants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Stars extends StatelessWidget {
  final double rating;
  const Stars({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemBuilder:
          (context, _) =>
              const Icon(Icons.star, color: GlobalVariables.secondaryColor),
    );
  }
}
