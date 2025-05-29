import 'package:dacn1/common/widgets/custom_button.dart';
import 'package:dacn1/contants/global_variables.dart';
import 'package:dacn1/features/admin/services/admin_services.dart';
import 'package:dacn1/providers/user_providers.dart';
import 'package:dacn1/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

import 'package:dacn1/models/order.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      onSuccess: () {},
    );
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Order Date: ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}'),
                      Text('Order ID: ${widget.order.id}'),
                      Text('Total Price: ${NumberFormat('#,###').format(widget.order.totalPrice)} vnđ'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: widget.order.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = widget.order.products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Image.network(product.images[0], height: 60, width: 60, fit: BoxFit.cover),
                      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Quantity: ${widget.order.quantity[index]}'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Tracking Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Stepper(
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  if (user.type == 'admin') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomButton(
                        text: 'Next Step',
                        onTap: () => changeOrderStatus(details.currentStep),
                        color: const Color(0xFF8447FF),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                steps: [
                  Step(
                    title: const Text('Pending'),
                    content: const Text('Your order is yet to be delivered.'),
                    isActive: currentStep >= 0,
                    state: currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Complete'),
                    content: const Text('Your order has been delivered, awaiting signature.'),
                    isActive: currentStep >= 1,
                    state: currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Received'),
                    content: const Text('Your order has been received and signed.'),
                    isActive: currentStep >= 2,
                    state: currentStep > 2 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Delivered'),
                    content: const Text('Order process is complete. Thank you!'),
                    isActive: currentStep >= 3,
                    state: currentStep >= 3 ? StepState.complete : StepState.indexed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
