import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:learn_megnagmet/controller/controller.dart';

import '../models/overview_page_grid_model.dart';
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';

class Overview extends StatefulWidget {
  final dynamic overviewData;
  final String fetchedCourseType;

  const Overview({
    Key? key,
    required this.overviewData,
    required this.fetchedCourseType,
  }) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late final dynamic overviewData;
  HomeController homecontroller = Get.put(HomeController());
  List<OverViewGrid> grid = [];
  bool activevalue = false;
  List<String> selectedCategory = [];

  String _cleanHtml(String html) {
    // Reuse same cleaning logic
    return html
        .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>'), '')
        .replaceAll(RegExp(r'class="[^"]*"'), '')
        .replaceAll(RegExp(r'\r\n'), '')
        .replaceAll('maimaar-tajweed', '')
        .replaceAll('container', '')
        .replaceAll('section', '')
        .replaceAll('cta', '')
        .replaceAll('whatsapp-icon', '');
  }

  @override
  void initState() {
    grid = Utils.getOverView();
    super.initState();
    overviewData = widget.overviewData;
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, String>> items = [
    //   {'image': 'assets/gridview1.png', 'title': '${overviewData['total_lessons']} Lessons'},
    //   {'image': 'assets/gridview2.png', 'title': overviewData['level'] ?? 'No Level'},
    //   {'image': 'assets/gridview3.png', 'title': overviewData['duration'] ?? 'No Duration'},
    //   {'image': 'assets/gridview4.png', 'title': overviewData['language'] ?? 'No Language'},
    //   {'image': 'assets/gridview5.png', 'title': 'Certificate'},
    //   {'image': 'assets/gridview6.png', 'title': 'Fully Secure'},
    // ];

    final String htmlDescription = overviewData['description'] ?? '';
    final String cleanHtml = _cleanHtml(htmlDescription);

    initializeScreenSize(context);

    return GetBuilder(
      init: HomeController(),
      builder: (controller) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                overviewData['title'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFF000000),
                  fontFamily: 'Gilroy',
                ),
              ),
              SizedBox(height: 12.h),

              /// Apply HTML rendering here
              if (cleanHtml.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFf9f9fb),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Html(
                    data: cleanHtml,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        backgroundColor: const Color(0xFFf9f9fb),
                      ),
                      "div": Style(
                        fontFamily: 'Gilroy',
                        fontSize: FontSize(16.sp),
                        color: const Color(0xFF333333),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        backgroundColor: const Color(0xFFf9f9fb),
                      ),
                      "header": Style(
                        backgroundColor: const Color(0xFF2c3e50),
                        color: Colors.white,
                        padding: HtmlPaddings.all(20),
                        textAlign: TextAlign.center,
                        fontSize: FontSize(28.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10),
                      ),
                      "h2": Style(
                        color: const Color(0xFF2c3e50),
                        fontSize: FontSize(20.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10),
                      ),
                      "p": Style(
                        fontFamily: 'Gilroy',
                        fontSize: FontSize(16.sp),
                        color: const Color(0xFF333333),
                        margin: Margins.only(bottom: 15),
                        lineHeight: LineHeight(1.5),
                      ),
                      "strong": Style(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      "b": Style(
                        fontWeight: FontWeight.bold,
                      ),
                      "ul": Style(
                        margin: Margins.only(bottom: 15),
                        padding: HtmlPaddings.only(left: 20),
                      ),
                      "li": Style(
                        fontFamily: 'Gilroy',
                        fontSize: FontSize(16.sp),
                        color: const Color(0xFF333333),
                        margin: Margins.only(bottom: 10),
                        lineHeight: LineHeight(1.5),
                      ),
                    },
                  ),
                ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
