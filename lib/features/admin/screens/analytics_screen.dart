import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../models/sales.dart';
import '../services/admin_services.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];

    earnings = (earningData['sales'] as List)
        .map((e) => Sales(e['label'], e['earning']))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng doanh thu: ${totalSales.toString()} VNĐ',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Doanh thu theo sản phẩm:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sản phẩm')),
                  DataColumn(label: Text('Doanh thu (VNĐ)')),
                ],
                rows: earnings!
                    .map(
                      (sale) => DataRow(
                    cells: [
                      DataCell(Text(sale.label)),
                      DataCell(Text(sale.earning.toString())),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
