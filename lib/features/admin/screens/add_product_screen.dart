import 'dart:core';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:dacn1/features/admin/services/admin_services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../contants/global_variables.dart';
import '../../../contants/utils.dart';
import '../../../models/product.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _addProductFormKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  List<String> productCategories = [
    'Mobiles',
    'Headsets',
    'Keyboards',
    'Speakers',
    'Microphones',
    'Mouse',
    'Watches',
    'Laptops',
    'Tablets',
    'Ipads'
  ];
  String? category;
  List<File> images = [];
  List<String> existingImages = [];

  Product? _product;
  bool _isEditing = false;
  bool _isInitialized = false;

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is Map<String, dynamic>) {
        _product = args['product'] as Product?;
        _isEditing = args['isEditing'] as bool? ?? false;

        if (_isEditing && _product != null) {
          productNameController.text = _product!.name;
          descriptionController.text = _product!.description;
          priceController.text = _product!.price.toString();
          quantityController.text = _product!.quantity.toString();
          category = _product!.category;
          existingImages = _product!.images;
        }
      } else {
        _isEditing = false;
      }

      _isInitialized = true;
    }
  }


  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        category: category!,
        price: int.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        images: images,
      );
    } else {
      showSnackBar(
        context,
        "Please fill all required fields and select images.",
      );
    }
  }

  void updateProduct() {
    if (_addProductFormKey.currentState!.validate() &&
        (images.isNotEmpty || existingImages.isNotEmpty)) {
      adminServices.updateProduct(
        context: context,
        id: _product!.id,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category!,
        newImages: images,
        existingImages: existingImages,
      );
    } else {
      showSnackBar(
        context,
        'Please fill all required fields and select images.',
      );
    }
  }

  // void selectImages() async {
  //   var res = await pickImages();
  //   setState(() {
  //     images = res;
  //   });
  // }
  void selectImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
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
            _isEditing ? 'Edit Product' : 'Add Product',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                (images.isNotEmpty || existingImages.isNotEmpty)
                    ? CarouselSlider(
                      items: [
                        // Hiển thị ảnh mới
                        ...images.map(
                              (file) => Stack(
                            children: [
                              Image.file(File(file.path), fit: BoxFit.cover, height: 200),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      images.remove(file); // Xóa ảnh khi bấm nút delete
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...existingImages.map(
                              (url) => Stack(
                            children: [
                              Image.network(url, fit: BoxFit.cover, height: 200),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      existingImages.remove(url);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 200,
                      ),
                    )
                    : GestureDetector(
                      onTap: selectImages,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder_open, size: 40),
                              const SizedBox(height: 15),
                              Text(
                                'Select Product Images',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: priceController, hintText: 'Price'),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        productCategories.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: _isEditing ? 'Update' : 'Sell',
                  onTap: _isEditing ? updateProduct : sellProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
