import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> data;

  const CategoryProductsChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, _) {
                final index = value.toInt();
                return index < data.length
                    ? Text(data[index].label)
                    : const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sales = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sales.earning.toDouble(),
            width: 16,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
