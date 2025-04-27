import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> sales;
  const CategoryProductsChart({Key? key, required this.sales})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: getMaxY(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Chuyển giá trị về kiểu int
                int intValue = value.toInt();

                String title;
                if (intValue >= 1000000) {
                  // Nếu giá trị lớn hơn hoặc bằng 1 triệu, hiển thị "M"
                  title = (intValue / 1000000).toInt().toString() + 'M'; // Chia cho 1 triệu và làm tròn
                } else if (intValue >= 1000) {
                  // Nếu giá trị lớn hơn hoặc bằng 1000, hiển thị "K"
                  title = (intValue / 1000).toInt().toString() + 'K'; // Chia cho 1000 và làm tròn
                } else {
                  // Nếu giá trị nhỏ hơn 1000, hiển thị nguyên số
                  title = intValue.toString(); // Hiển thị số nguyên
                }

                return Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                );
              },
            ),
          ),

          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            sales
                .asMap()
                .map((index, sale) {
                  return MapEntry(
                    index,
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: sale.earning.toDouble(),
                          color: Colors.blueAccent,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                })
                .values
                .toList(),
      ),
    );
  }

  double getMaxY() {
    double maxEarning = 0;
    for (var sale in sales) {
      if (sale.earning > maxEarning) {
        maxEarning = sale.earning.toDouble();
      }
    }
    return maxEarning + 10;
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= sales.length) return const SizedBox.shrink();
    return Text(
      sales[index].label,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );
  }
}
