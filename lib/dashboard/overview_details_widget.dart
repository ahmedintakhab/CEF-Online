import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/api_constants.dart'; // Import your ApiConstants

class OverviewDetailsWidget extends StatefulWidget {
  const OverviewDetailsWidget({super.key});

  @override
  _OverviewDetailsWidgetState createState() => _OverviewDetailsWidgetState();
}

class _OverviewDetailsWidgetState extends State<OverviewDetailsWidget> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> monthlyData = [];

  // Define custom colors that match the screenshot closely
  final Color attendedColor = const Color(0xFF8BC34A); // Light Green
  final Color missedColor = const Color(0xFFF06292);  // Light Pink/Red

  @override
  void initState() {
    super.initState();
    fetchMonthlyClasses();
  }

  Future<void> fetchMonthlyClasses() async {
    print("🔄 Fetching Monthly Classes API...");
    final url = "${ApiConstants.baseUrl}student/monthlyClasses";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Monthly Classes API response: ${response.statusCode}");
        setState(() {
          monthlyData = data is List ? data : [];
          isLoading = false;
        });
      } else {
        print("❌ Monthly Classes API Error: ${response.statusCode}");
        setState(() {
          errorMessage = "Failed to load data (Code: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Exception in Monthly Classes API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to build the BarChartData dynamically
  BarChartData _buildBarChartData() {
    // Find the maximum value for normalization (0–1 scale)
    double maxValue = 1.0;
    if (monthlyData.isNotEmpty) {
      maxValue = monthlyData.map((item) => (item['total_Completed_Classes'] + item['total_Missed_Classes']).toDouble()).reduce((a, b) => a > b ? a : b);
      maxValue = maxValue > 0 ? maxValue : 1.0; // Avoid division by zero
    }

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 1.0, // Maximum Y-axis value is 1 (normalized)
      barTouchData: BarTouchData(enabled: false), // Disable touch interactions
      gridData: const FlGridData(show: false), // Remove grid lines
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1, // Only show titles at 0 and 1
            getTitlesWidget: (value, meta) {
              if (value == 0 || value == 1) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < monthlyData.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    monthlyData[index]['month_Name'],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      barGroups: monthlyData.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final attendedY = maxValue > 0 ? item['total_Completed_Classes'] / maxValue : 0.0;
        final missedY = maxValue > 0 ? item['total_Missed_Classes'] / maxValue : 0.0;
        return _buildBarGroup(index, attendedY, missedY);
      }).toList(),
    );
  }

  // Helper function to create a BarChartGroupData for a month
  BarChartGroupData _buildBarGroup(int x, double attendedY, double missedY) {
    const double barWidth = 10;
    const double groupSpace = 10;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: attendedY,
          color: attendedColor,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
        ),
        BarChartRodData(
          toY: missedY,
          color: missedColor,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
        ),
      ],
      barsSpace: 1, // Small space between the Attended and Missed bar
    );
  }

  // Helper function to build the circular legend item
  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildLegend(attendedColor, "Attended"),
              SizedBox(width: 16.w),
              _buildLegend(missedColor, "Missed"),
            ],
          ),
          SizedBox(height: 16.h),
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF8BC34A)),
              ),
            )
          else if (monthlyData == null || monthlyData.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No monthly data available',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              ),
            )
          else
            Expanded(
              child: BarChart(
                _buildBarChartData(),
              ),
            ),
        ],
      ),
    );
  }
}