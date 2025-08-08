import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../utils/api_constants.dart';
import '../../widget/custom_text_form_field.dart';

class CoursesDropdown extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int courseTypeId;
  final Function(int courseId, String courseName)? onCourseSelected;

  const CoursesDropdown({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.courseTypeId,
    this.onCourseSelected,
  }) : super(key: key);

  @override
  _CoursesDropdownState createState() => _CoursesDropdownState();
}

class _CoursesDropdownState extends State<CoursesDropdown> {
  String? selectedValue;
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  bool hasError = false;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    final cachedCourses = await _getCachedCourses();
    if (cachedCourses != null && cachedCourses.isNotEmpty) {
      setState(() {
        courses = cachedCourses;
        filteredCourses = cachedCourses;
        isLoading = false;
      });
    }

    await _fetchCourses();
  }

  Future<List<Map<String, dynamic>>?> _getCachedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('courses_${widget.courseTypeId}');
      if (cachedData != null) {
        return List<Map<String, dynamic>>.from(json.decode(cachedData));
      }
    } catch (e) {
      print('Error loading cached courses: $e');
    }
    return null;
  }

  Future<void> _cacheCourses(List<Map<String, dynamic>> courses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'courses_${widget.courseTypeId}',
        json.encode(courses),
      );
      await prefs.setInt(
        'courses_${widget.courseTypeId}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error caching courses: $e');
    }
  }

  Future<bool> _shouldRefreshCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('courses_${widget.courseTypeId}_timestamp');
      if (timestamp == null) return true;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      return cacheAge > 24 * 60 * 60 * 1000; // Refresh if older than 24 hours
    } catch (e) {
      return true;
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final shouldRefresh = await _shouldRefreshCache();
      if (!shouldRefresh && courses.isNotEmpty) return;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}frontend/get-courses-by-type?type_id=${widget.courseTypeId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final loadedCourses = jsonResponse.map<Map<String, dynamic>>((course) => {
          'course_id': course['course_id'],
          'course_name': course['course_name'].toString(),
        }).toList();

        await _cacheCourses(loadedCourses);

        setState(() {
          courses = loadedCourses;
          filteredCourses = loadedCourses;
          isLoading = false;
        });
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCourses = courses
          .where((course) => course['course_name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  widget.hintText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Gilroy',
                    color: const Color(0XFF9B9B9B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                items: filteredCourses
                    .map((Map<String, dynamic> course) => DropdownMenuItem<String>(
                  value: course['course_name'],
                  child: Text(
                    course['course_name'],
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                    widget.controller.text = value ?? '';
                    hasError = false;
                    state.didChange(value);
                    _searchController.text = value ?? '';
                    if (value != null) {
                      final selectedCourse = courses.firstWhere(
                            (course) => course['course_name'] == value,
                      );
                      widget.onCourseSelected?.call(
                        selectedCourse['course_id'],
                        selectedCourse['course_name'],
                      );
                    }
                  });
                },
                dropdownSearchData: DropdownSearchData(
                  searchController: _searchController,
                  searchInnerWidgetHeight: 70.h,
                  searchInnerWidget: Container(
                    height: 70.h,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: customTextFormField(
                      controller: _searchController,
                      hintText: 'Search course...',
                      validator: (val) {},
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value
                        .toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: hasError ? Colors.red : const Color(0XFFDEDEDE),
                      width: 1,
                    ),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 40.h,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0XFF8CC13F),
                      width: 1,
                    ),
                    color: const Color(0xFFF5F5F5),
                  ),
                  maxHeight: 200.h,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}