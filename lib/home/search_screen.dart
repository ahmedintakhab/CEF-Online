import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/controller.dart';
import '../cources/cources.dart';
import '../login/login_empty_state.dart';
import '../models/design_list.dart';
import '../models/recently_added.dart';
import '../models/trending_cource.dart';
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';
import 'filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  final String slug;
  const SearchScreen({Key? key, required this.slug}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchScreenController searchScreenController =
  Get.put(SearchScreenController());

  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  List<Map<String, dynamic>> courseSuggestions = []; // Suggestions for courses
  List<String> selectedCategory = [];
  List<Design> design = Utils.getDesign();
  List<Trending> cource = Utils.getTrending();
  List<Recent> recentAdded = Utils.getRecentAdded();
  Map<String, dynamic>? searchData; // Variable to store API data
  List<Map<String, dynamic>> categorywithimages = []; // Dynamic category list
  List<Map<String, dynamic>> categoryData = []; // Store categories
  Map<String, List<dynamic>> subcategoriesData = {}; // Store subcategories
  List<Map<String, dynamic>> courseResult = []; // Dynamic category list
  String lastQuery = ""; // To track the last query
  bool noResultsFound = false; // Flag for no results
  bool isLoading = false;
  String errorMessage = ''; // Track errors





  @override
  void initState() {
    super.initState();
    searchCourses();
    fetchCategoriesAndSubcategories(); // Fetch data when Search Screen loads
    // Listener for text changes
    searchController.addListener(() {
      final query = searchController.text.trim();
      if (query != lastQuery) {
        onSearchTextChanged(query);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }





 Future<void> searchCourses({String query = ""}) async {
   setState(() {
     isLoading = true; // Start loading
     noResultsFound = false; // Reset no results flag
   });
  const url = 'https://cefonlineacademy.com/api/frontend/course/search';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: query.isNotEmpty ? json.encode({'keyword': query}) : null,
      headers: {'Content-Type': 'application/json'},

    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(
        data['course_results'] ?? [],

      );
      setState(() {
        courseSuggestions = results;
        if (results.isEmpty && query.isNotEmpty) {
          // If no results are found and a query is entered, display "No results found"
          noResultsFound = true;
        } else {
          noResultsFound = false; // If results are found, reset noResultsFound
        }
        searchData = data;
        categorywithimages = List<Map<String, dynamic>>.from(data['categories_with_images'] ?? []);
        courseResult = List<Map<String, dynamic>>.from(data['course_results'] ?? []);
      });
      print("Fetched data: $courseResult");
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (error) {
    print("API Error: $error");
  }
  finally {
    setState(() {
      isLoading = false; // Stop loading
    });
    // If no results found, after a short delay, display "No results found"
    if (courseSuggestions.isEmpty && query.isNotEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          noResultsFound = true;
        });
      });
    }

  }
}

void onSearchTextChanged(String query) {
  if (debounce?.isActive ?? false) debounce!.cancel();
  debounce = Timer(const Duration(milliseconds: 500), () {
    lastQuery = query; // Update the last query
    if (query.isNotEmpty) {
      searchCourses(query: query); // Fetch suggestions
    }
    else {
      setState(() {
        isLoading = false;
        courseSuggestions.clear();
        noResultsFound = false; // No "no results" message
          searchCourses();
      });
    }
  });
}
  Future<void> fetchCategoriesAndSubcategories() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://cefonlineacademy.com/api/frontend/all-categories-with-subcategories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Raw API Response: $data');

        setState(() {
          categoryData = data
              .where((category) => category['category_name'] != null) // Filter out null categories
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

          isLoading = false;
        });

        print('Processed Categories: $categoryData');
        print('Stored Subcategories: $subcategoriesData');
      } else {
        setState(() {
          errorMessage = 'Failed to load categories';
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    print("Check the slug for search: ${widget.slug}");
    initializeScreenSize(context);

    // return WillPopScope(
    //   onWillPop: (){
    //     return Future.value(false);
    //   },
    //   child:);
       return Scaffold(
        body: GetBuilder<SearchScreenController>(
            init: SearchScreenController(),
            builder: (controller) => SafeArea(
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Image(
                              image: const AssetImage("assets/back_arrow.png"),
                              height: 24.h,
                              width: 24.w,
                            )),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          shrinkWrap: true,
                          //padding: EdgeInsets.zero,
                          primary: true,
                          children: [
                             search_text_field(),
                            SizedBox(height: 20),
                            const SizedBox(width: 20, height: 10,),
                            Text(
                              "Categories",
                              style:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 20.h),
                            horizontal_disidn(),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Courses",
                                style:
                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: [
                                trending_cource(),
                                if (noResultsFound && !isLoading)

                                  const Text(
                                    'No courses found',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                            // SizedBox(height: 20.h),
                            // recent_added_list(),
                          ],
                        ),
                      )
                    ],
                  ),
            )),
      );

  }

  Widget search_text_field() {
    return Container(
      height: 50.h,
      child: TextFormField(
        controller: searchController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF78A03F), width: 1.w),
                  borderRadius: BorderRadius.circular(22.h)),
              hintText: 'Search',
              hintStyle: TextStyle(
                  color: const Color(0XFF9B9B9B),
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400),
              prefixIcon: Image(
                image: AssetImage('assets/search.png'),
                height: 24.h,
                width: 24.w,
              ),
              suffixIcon: GestureDetector(

                onTap: () {
                  final query = searchController.text.trim(); // Get the query
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.h),
                      ),
                      context: context,
                      builder: (context) =>  FilterSheet(
                        query: query,
                        categoryData: categoryData, // Pass categories
                        subcategoriesData: subcategoriesData, // Pass subcategories
                        onFilterApplied: (filteredCourses) {
                          setState(() {
                            courseSuggestions = List<Map<String, dynamic>>.from(filteredCourses);
                            courseResult = courseSuggestions;
                          });
                          searchController.clear();
                        },
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 5.h,
                    width: 5.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/filtericon.png"),
                        // fit: BoxFit.contain, // Ensures proper scaling
                        colorFilter: ColorFilter.mode(
                          Color(0xFF8CC13F), // Use your desired color here
                          BlendMode.srcIn,  // Applies the color filter to the image
                        ),
                      ),
                    ),
                  ),
                ),

              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.h)))),
    );
  }

  Widget horizontal_disidn() {
    return Container(
      height: 150.h, // Adjusted to fit both image and text
      width: double.infinity.w,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categorywithimages.length,
        itemBuilder: (BuildContext context, index) {
          final category = categorywithimages[index]; // Access each category

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
            child: Column( // Using Column to stack image and text vertically
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: Image(
                    image: NetworkImage(category['image'] ?? 'No image'),
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),

                // Text container below the image
                Container(
                  width: 120.w, // Ensure text container is the same width as the image
                  padding: EdgeInsets.symmetric(horizontal: 5.w , vertical: 8.h),
                  child: Text(
                    category['name'] ?? 'No Name',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, // Center the text below the image
                    style: TextStyle(
                      color: Color(0XFF000000),
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      height: 1.1, // Adjust line height for better text display
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget trending_cource() {
    if (courseResult == null || courseResult.isEmpty) {
      return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0XFF8CC13F),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No Result found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }
        },
      );
    }
    return SizedBox(
      height: 302.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courseResult.length,
        itemBuilder: (BuildContext context, int index) {
          final courses = courseResult[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: GestureDetector(
              onTap: () {
                final slug = courses['course_slug']; // Fetch the slug from the course data
                print("Slug tapped: $slug"); // Debug print
                if (slug != null) {
                  Get.to(() => MyCources(slug: slug)); // Navigate to MyCources with the slug
                } else {
                  print("Slug is null"); // Debug print
                }
              },
              child: Container(
                height: 302.h,
                width: 177.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0XFF23408F).withOpacity(0.14),
                      offset: const Offset(-4, 5),
                      blurRadius: 16.h,
                    ),
                  ],
                  color: const Color(0XFFFFFFFF),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 165.h,
                      width: 190.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(courses['course_image'].toString()),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12.h),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10.h,
                          left: 10.w,
                          bottom: 130.h,
                          right: 130.w,
                        ),
                        child: Container(
                          height: 30.h,
                          width: 30.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Image(
                              image: const AssetImage("assets/like.png"),
                              height: 13.08.h,
                              width: 13.08.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w, right: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          Text(
                            courses['course_title'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gilroy',
                              color: const Color(0XFF000000),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 27.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.h),
                                    color: const Color(0XFFFAF4E1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image(
                                        image: AssetImage("assets/staricon.png"),
                                        height: 15.h,
                                        width: 15.w,
                                      ),
                                      Text(
                                        courses['star_rating'].toString(),
                                        style: TextStyle(
                                          color: const Color(0XFFFFC403),
                                          fontFamily: 'Gilroy',
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: SizedBox(
                                    height: 21.h,
                                    width: 76.w,
                                    child: courses['duration'] != null && courses['duration'] != 0
                                        ? Row(
                                      children: [
                                        Image(
                                          image: AssetImage("assets/clock.png"),
                                          height: 17.h,
                                          width: 17.w,
                                          color: Color(0XFF8CC13F),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${courses['duration'].toString()} Days',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: const Color(0XFF000000),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                      ],
                                    )
                                        : SizedBox.shrink(), // If the condition is false, render an empty widget
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (courses['course_price'] != null && courses['course_price'].toString() != "Rs 0.00")
                                  ...[
                                  Text('Price:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                // Row(
                                //   children: [
                                //     Image(
                                //       image: NetworkImage(courses['user_pic'].toString()),
                                //       height: 30.h,
                                //       width: 30.w,
                                //     ),
                                //     SizedBox(width: 6.w),
                                //   ],
                                // ),
                                  Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.h),
                                      color: const Color(0XFFEBF2C2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        courses['course_price'] ?? 'Null',
                                        style: TextStyle(
                                          color: Color(0XFF78A03F),
                                          fontFamily: 'Gilroy',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
