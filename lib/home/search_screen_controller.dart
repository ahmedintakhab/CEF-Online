import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchScreenController extends GetxController {
  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  List<Map<String, dynamic>> courseSuggestions = [];
  List<String> selectedCategory = [];
  Map<String, dynamic>? searchData;
  List<Map<String, dynamic>> categorywithimages = [];
  List<Map<String, dynamic>> categoryData = [];
  Map<String, List<dynamic>> subcategoriesData = {};
  List<Map<String, dynamic>> courseResult = [];
  String lastQuery = "";
  bool noResultsFound = false;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      final query = searchController.text.trim();
      if (query != lastQuery) {
        onSearchTextChanged(query);
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    debounce?.cancel();
    super.onClose();
  }

  Future<void> searchCourses({String query = ""}) async {
    isLoading = true;
    noResultsFound = false;
    update();

    const url = 'https://cefonlineacademy.com/api/frontend/course/search';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: query.isNotEmpty ? json.encode({'keyword': query}) : null,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = List<Map<String, dynamic>>.from(data['course_results'] ?? []);
        courseSuggestions = results;
        noResultsFound = results.isEmpty && query.isNotEmpty;
        searchData = data;
        categorywithimages = List<Map<String, dynamic>>.from(data['categories_with_images'] ?? []);
        courseResult = List<Map<String, dynamic>>.from(data['course_results'] ?? []);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("API Error: $error");
    } finally {
      isLoading = false;
      update();
      if (courseSuggestions.isEmpty && query.isNotEmpty) {
        Future.delayed(const Duration(seconds: 3), () {
          noResultsFound = true;
          update();
        });
      }
    }
  }

  void onSearchTextChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      lastQuery = query;
      if (query.isNotEmpty) {
        searchCourses(query: query);
      } else {
        isLoading = false;
        courseSuggestions.clear();
        noResultsFound = false;
        searchCourses();
        update();
      }
    });
  }

  Future<void> fetchCategoriesAndSubcategories() async {
    isLoading = true;
    errorMessage = '';
    update();

    try {
      final response = await http.get(
        Uri.parse('https://cefonlineacademy.com/api/frontend/all-categories-with-subcategories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        categoryData = data
            .where((category) => category['category_name'] != null)
            .map((category) {
          final Map<String, dynamic> categoryMap = {
            'category_id': category['category_id'],
            'category_name': category['category_name'],
            'has_subcategories': false,
          };

          if (category['category_subcategories'] != null &&
              (category['category_subcategories'] as List).isNotEmpty) {
            categoryMap['has_subcategories'] = true;
            subcategoriesData[category['category_id'].toString()] =
            List<dynamic>.from(category['category_subcategories']);
          }

          return categoryMap;
        }).toList();
      } else {
        errorMessage = 'Failed to load categories';
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      update();
    }
  }
}