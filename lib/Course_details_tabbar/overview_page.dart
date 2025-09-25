import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/Course_details_tabbar/course_footer.dart';
import 'package:flutter_html/flutter_html.dart';

class OverviewPage extends StatelessWidget {
  final Map<String, dynamic> overviewData;

  const OverviewPage({Key? key, required this.overviewData}) : super(key: key);

  String _cleanHtml(String html) {
    // Remove CSS styles and simplify HTML
    return html
        .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>'), '') // Remove style tags
        .replaceAll(RegExp(r'class="[^"]*"'), '') // Remove class attributes
        .replaceAll(RegExp(r'\r\n'), '') // Remove line breaks
        .replaceAll('maimaar-tajweed', '') // Remove specific class names
        .replaceAll('container', '')
        .replaceAll('section', '')
        .replaceAll('cta', '')
        .replaceAll('whatsapp-icon', '');
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> apiKeyPoints = overviewData['keyPoints'] ?? [];
    final List<String> keyPoints = apiKeyPoints.isNotEmpty
        ? apiKeyPoints.map((point) => point['name'] as String).toList()
        : [];

    final String htmlDescription = overviewData['description'] ?? '';
    final String cleanHtml = _cleanHtml(htmlDescription);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Key Points
              if (keyPoints.isNotEmpty) ...[
                ...keyPoints.map((point) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEBF2C2),
                        ),
                        child: Icon(
                          Icons.check,
                          color: const Color(0xFF8CC13F),
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 20.h),
              ],

              // HTML Content with custom styling
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

              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 20.h),
                child: overviewData.containsKey('footer_section')
                    ? CourseFooter(footerData: overviewData['footer_section'])
                    : CourseFooter(),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}