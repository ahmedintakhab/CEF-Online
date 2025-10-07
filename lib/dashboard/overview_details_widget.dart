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

  // Dynamic Y-Axis properties
  double maxTotalClasses = 0;
  double chartMaxY = 5.0; // Default or calculated value

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

        List<dynamic> fetchedData = data is List ? data : [];

        // 1. Calculate max total classes
        double maxVal = 0;
        for (var item in fetchedData) {
          final total = (item['total_Completed_Classes'] ?? 0) + (item['total_Missed_Classes'] ?? 0);
          if (total > maxVal) {
            maxVal = total.toDouble();
          }
        }

        // 2. Determine a suitable max Y-axis value
        double determinedMaxY = maxVal;
        if (maxVal > 0) {
          // If maxVal is, say, 4, we want maxY to be 5.
          // If maxVal is 10, we want maxY to be 10 (or 11 if using a buffer).
          // We'll set it to the next whole number + 1, unless it's very large.
          determinedMaxY = (maxVal.ceil() + 1).toDouble();
          // Ensure it's at least 5 for a good visual scale if the data is small
          if (determinedMaxY < 5) determinedMaxY = 5.0;
        } else {
          determinedMaxY = 5.0; // Default to 5 if no data
        }

        setState(() {
          monthlyData = fetchedData;
          maxTotalClasses = maxVal;
          chartMaxY = determinedMaxY;
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
    return BarChartData(
      alignment: BarChartAlignment.center,
      maxY: chartMaxY, // Use the dynamically calculated max Y
      barTouchData: BarTouchData(enabled: false), // Disable touch interactions
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: chartMaxY > 10 ? 5 : 1, // Draw line every 1 unit
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 0.5,
          );
        },
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            // Show titles only at 0 and the max value (chartMaxY - 1, which is the ceiling of the max data)
            interval: chartMaxY - 1,
            getTitlesWidget: (value, meta) {
              if (value == 0) {
                return Text('0', style: const TextStyle(fontSize: 10));
              }
              // Display the actual maximum total count (before padding)
              if (value == chartMaxY - 1) {
                return Text((chartMaxY - 1).toInt().toString(), style: const TextStyle(fontSize: 10));
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
                    monthlyData[index]['month_Name'].substring(0, 3), // Show 3-letter month name
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
        border: Border(
          // Only show the bottom border line for the X-axis
          bottom: BorderSide(color: Colors.grey.withOpacity(0.7), width: 1),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      barGroups: monthlyData.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final attended = (item['total_Completed_Classes'] ?? 0).toDouble();
        final missed = (item['total_Missed_Classes'] ?? 0).toDouble();

        return _buildStackedBarGroup(index, attended, missed);
      }).toList(),
    );
  }

  // Helper function to create a BarChartGroupData for a month (STACKED)
  BarChartGroupData _buildStackedBarGroup(int x, double attendedY, double missedY) {
    const double barWidth = 20;

    // The Missed part is on top of the Attended part
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          // total height of the rod is Attended + Missed
          toY: attendedY + missedY,
          width: barWidth,
          // Colors are applied as items in a BarChartRodStackItem list
          rodStackItems: [
            // Attended: Base segment
            BarChartRodStackItem(
              0, // Start from 0
              attendedY, // End at Attended value
              attendedColor,
            ),
            // Missed: Top segment
            BarChartRodStackItem(
              attendedY, // Start where Attended ended
              attendedY + missedY, // End at Total value
              missedColor,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.zero), // Managed by RodStackItems
        ),
      ],
      // No space needed between segments in a stack
      barsSpace: 0,
      groupVertically: true, // Crucial for stacking
    );
  }

  // Helper function to build the circular legend item (minor change for style)
  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil if not already done in the parent
    // ScreenUtil.init(context, designSize: const Size(360, 690));

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
              // fontFamily: 'Gilroy', // Commented out if not standard Flutter font
            ),
          ),
          SizedBox(height: 6.h),
          Divider(
            thickness: 1.0,
            color: Colors.grey[300],
          ),
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
          else if (monthlyData.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No monthly data available',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              ),
            )
          else
          // Added Padding to give space for the left titles
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 38.w, left: 6.w),
                child: BarChart(
                  _buildBarChartData(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}