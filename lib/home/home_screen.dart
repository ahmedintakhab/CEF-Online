import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/cources/cources.dart';
import 'package:learn_megnagmet/home/recent_added_cource_detail.dart';

import 'package:learn_megnagmet/home/recently_added_cources.dart';
import 'package:learn_megnagmet/home/search_screen.dart';
import 'package:learn_megnagmet/home/trending_cource.dart';
import 'package:learn_megnagmet/models/design_list.dart';
import 'package:learn_megnagmet/models/home_slider.dart';
import 'package:learn_megnagmet/models/recently_added.dart';
import 'package:learn_megnagmet/models/trending_cource.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../utils/screen_size.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User Name"; // Default placeholder
  List<HomeSlider> pages = [];
  List<Design> design = Utils.getDesign();
  List<Trending> trendingCource = Utils.getTrending();
  List<Recent> recentAdded =Utils.getRecentAdded();
  HomeController homecontroller = Get.put(HomeController());
  Map<String, dynamic>? apiData;
  bool isLoading = true; // Add loading state




  // int currentpage = 0;
  PageController controller = PageController();
  bool buttonvalue= false;
  int currentvalue = 0;
  List userDetail = Utils.getUser();
  @override
  void initState() {
    pages = Utils.getHomeSliderPages();
    super.initState();
    fetchApiData();
    _loadUserData();
    // searchCourses();

  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "User Name";
    });
  }
  toggle(int index){
   setState(() {

     if(trendingCource[index].buttonStatus==true){
    trendingCource[index].buttonStatus = false;
   }
   else{
       trendingCource[index].buttonStatus = true;
     }});
  }
  toggleRecent(int index){
    setState(() {

      if(recentAdded[index].buttonStatus==true){
        recentAdded[index].buttonStatus = false;
      }
      else{
        recentAdded[index].buttonStatus = true;
      }});
  }
  Future<void> fetchApiData() async {
    final url = Uri.parse("https://cefonlineacademy.com/api/frontend/home");
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(url,
        headers: {
          'Authorization': 'Bearer $token', // Pass the token as a Bearer token
          'Content-Type': 'application/json', // Optional: Set content type
        },
      );

      if (response.statusCode == 200) {
        print("API successfully fetched data!");
        final data = json.decode(response.body);
        print("API Data: $data"); // Print the full API data
        setState(() {
          apiData = data;
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        print("Error: Failed to fetch data. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) => SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 16.h),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(children: [
                        Image(image: AssetImage(userDetail[0].image),height: 50.h,width: 49.93.w,),
                         SizedBox(width: 10.w),
                        Text("Welcome, $userName",
                            style:  TextStyle(
                                fontFamily: 'Gilroy',
                                color: const Color(0XFF000000),
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700))
                      ]),
                    ),
                     SizedBox(height: 30.h),
                    Expanded(
                      child: ListView(
                        // physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        primary: true,
                        children: [
                          Container(

                            height: 50.h,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 20.w),
                              child: TextFormField(
                                  onTap: () {
                                    Get.to(()=>SearchScreen());
                                  },
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:  BorderSide(
                                              color: const Color(0XFF23408F), width: 1.w),
                                          borderRadius: BorderRadius.circular(22)),
                                      hintText: 'Search',
                                      hintStyle:  TextStyle(
                                          color: Color(0XFF9B9B9B),
                                          fontSize: 15.sp,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w400),
                                      prefixIcon:  Image(
                                        image: AssetImage('assets/search.png'),
                                        height: 24.h,
                                        width: 24.w,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {

                                        },
                                        child: Container(
                                          height: 5.h,
                                          width: 5.w,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFF8CC13F), // Desired color
                                              BlendMode.srcIn,   // Applies the color to the image
                                            ),
                                            // child: Image.asset("assets/filico.png"),
                                          ),
                                        ),

                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22)))),
                            ),
                          ),
                           SizedBox(height: 20.h),
                          generatePage(),
                           SizedBox(height: 20.h),
                          indicator(),
                           SizedBox(height: 20.h),
                          horizontal_disidn(),
                           SizedBox(height: 22.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text("Latest Course",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Gilroy')),
                                TextButton(
                                    onPressed: () {
                                      Get.to(()=> TrendingCource());
                                    },
                                    child:  Text("See All",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: 'Gilroy',
                                            color: const Color(0XFF78A03F),
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          trending_cource_list(apiData ??{}),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text("Recently Added Course",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Gilroy')),
                                TextButton(
                                    onPressed: () {
                                      Get.to(const RecentlyAdded());
                                    },
                                    child:  Text("See All",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 18.sp,
                                            color: const Color(0XFF78A03F),
                                            fontWeight: FontWeight.w700)))
                              ],
                            ),
                          ),
                          recent_added_list(apiData ?? {}),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generatePage() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: false,
        enableInfiniteScroll: true,
        initialPage: 0,
        height: 150.0.h,
        enlargeCenterPage: false,
        viewportFraction: 0.84,
        onPageChanged: (index, reason) {
          homecontroller.onChange(index.obs);
        },
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        // Check if apiData is null
        // if (apiData == null) {
        //   print("API data is null!");
        //   return Center(child: CircularProgressIndicator());
        // }

        // Check if banners field is null
        final banners = apiData?['banners'];

        if (banners == null) {
          return Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F)));
        }

        // Check if image URL is valid
        final imageUrl = banners['image'] ?? '';
        bool isValidImageUrl = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;

        // if (isValidImageUrl) {
        //   print("Valid Image URL: $imageUrl");
        // } else {
        //   print("Invalid Image URL, fallback to default image");
        // }

        return Padding(
          padding: EdgeInsets.only(
              left: index == 0 ? 0.w : 12.w, right: index == 2 ? 12.w : 0.w),
          child: Container(
            height: 150.h,
            width: 322.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isValidImageUrl
                    ? NetworkImage(imageUrl) // Use image from API
                    : AssetImage('assets/person.png') as ImageProvider, // Fallback image
                fit: BoxFit.cover, // Ensure the image covers the area
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 25.w, right: 110.w),
                  child: Text(
                    banners['title'] ?? '', // Use title from API
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0XFF000000),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 29.sp),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: GestureDetector(
                    onTap: () {
                      // Open the link when "Get Start" is clicked
                      final link = banners['link'];
                      if (link != null && link != "#" && Uri.tryParse(link) != null) {
                        launchUrl(Uri.parse(link));
                      }
                    },
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                        color: const Color(0XFF78A03F),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy',
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: (apiData?['banners'] != null) ? 1 : 0, // Only 1 banner object
    );
  }

  Widget indicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pages.length, (index) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 6.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 10.h,
              width: 10.w,
              //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (index == homecontroller.currentpage.value)
                      ? const Color(0XFF8CC13F)
                      : const Color(0XFFDEDEDE)),
            ),
          );
        }));
  }

  Widget design_list() {
    return Expanded(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: design.length,
          itemBuilder: (BuildContext context, index) {
            return Stack(
              children: [Image(image: AssetImage(design[index].image!),
                height: 110.h,width: 110.h,)],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget horizontal_disidn() {
    final categories = apiData?['categories']; // Fetch categories from apiData

    if (categories == null || categories.isEmpty) {
      return Center(
        child: Text(
          'No categories available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 150.h, // Adjust height to fit image and name together
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, index) {
          final category = categories[index]; // Access each category from the list

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                      child: Image(image: NetworkImage(category['image']), // Fetch image
                        height: 100.h,
                        width: 100.w,
                     fit: BoxFit.cover,),


                ),
                SizedBox(height: 6.h), // Space between image and text
                Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 5.w , vertical: 8.h),

                  child: Text(
                    category['name'] ?? '',
                    maxLines: 2, // Fetch name
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFF000000),
                      fontSize: 12.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
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


  Widget trending_cource_list(Map<String, dynamic> apiData) {
    final trendingCourses = apiData['trendingCourses']; // Fetch trendingCourses from apiData
// print('Details of TrendingCourses : $trendingCourses');
    if (trendingCourses == null || trendingCourses.isEmpty) {
      return Center(
        child: Text(
          'No trending courses available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 234.h,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount:trendingCourses.length,
        itemBuilder: (BuildContext context, index) {
          final course = trendingCourses[index]; // Access each course from the list

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: GestureDetector(
              onTap: () {
                final slug = course['slug']; // Fetch the slug from the course data
                if (slug != null) {
                  Get.to(MyCources(slug: slug));
                }
              },

              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 172.h,
                      width: 177.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        image: DecorationImage(
                          image: NetworkImage(course['image'] ?? ''), // Fetch image from API
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 147.w,
                          bottom: 142.h,
                        ),
                        child: Container(
                          height: 20.h,
                          width: 20.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                toggle(index);
                              },
                              child: course['buttonStatus'] == true
                                  ? Image(
                                image: AssetImage("assets/saveboldblue.png"),
                                height: 10.h,
                                width: 9.w,
                              )
                                  : Image(
                                image: AssetImage("assets/savebold.png"),
                                height: 10.h,
                                width: 9.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    SizedBox(
                      width: 177.w, // Same width as the image
                      child: Text(
                        course['title'] ?? '', // Fetch title from API
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          color: const Color(0XFF000000),
                        ),
                        maxLines: 2, // Allow at most 2 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                        softWrap: true, // Ensure wrapping
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      course['subtitle'] ?? '', // Optional subtitle (check if it exists in the API)
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: const Color(0XFF000000),
                      ),
                    ),
                  ],
                ),


            ),
          );
        },
      ),
    );
  }


  Widget recent_added_list(Map<String, dynamic> apiData) {
    final newCourses = apiData?['latestCourses'] ?? []; // Fetch latestcourses from apiData
// Initialize recentAdded dynamically with the same length as newCourses
    List<Map<String, dynamic>> recentAdded = List.generate(
      newCourses.length,
          (index) => {'buttonStatus': false}, // Default buttonStatus to false
    );
    if (newCourses == null || newCourses.isEmpty) {
      return Center(
        child: Text(
          'No latest courses available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }
    return Container(
      color: const Color(0XFFFFFFFF),
      height: 323.h,
      width: double.infinity.w,
      child: ListView.builder(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          physics: const BouncingScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: newCourses.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            final latest = newCourses[index]; // Access each course from the list
            return GestureDetector(
              onTap: (){
                Get.to(RecentCourceDetail(corcedetail: latest,));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                 horizontal: 4.w
                ),
                child: Container(
                  //height: 323,
                  width: 276.w,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16),
                      ],
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 158.h,
                          width: 276.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(latest['image'].toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.only(
                                right: 230.w, bottom: 120.h, top: 10.h),
                            child: Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white),
                                child: IconButton(
                                    splashRadius: 10,
                                    onPressed: () {
                                      setState(() {
                                        // Toggle buttonStatus
                                        recentAdded[index]['buttonStatus'] =
                                        !recentAdded[index]['buttonStatus'];
                                      });
                                    },

                                    icon:  Center(
                                      child: recentAdded[index]['buttonStatus']
                                          ? Image.asset(
                                        "assets/saveboldblue.png",
                                        height: 10.h,
                                        width: 9.w,
                                      )
                                        :Image(
                                          image: AssetImage("assets/savebold.png"),
                                          height: 10.h,
                                          width: 9.w,
                                        ),
                                    )
                                )
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: 10.w, top: 10.h),
                              child: Container(
                                height: 25.h,
                                width: 58.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0XFFFAF4E1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     Image(
                                      image: const AssetImage("assets/staricon.png"),
                                      height: 17.h,
                                      width: 17.w,
                                    ),
                                    Text(
                                      latest['star_rating'].toString(),
                                      style:  TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: const Color(0XFFFFC403),
                                          fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: latest['duration'] != null && latest['duration'] != 0
                                  ? Row(
                                children: [
                                  Image(
                                    image: const AssetImage("assets/clock.png"),
                                    height: 17.h,
                                    width: 17.w,
                                    color: Color(0XFF8CC13F),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${latest['duration']} Day's",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Color(0XFF000000),
                                      fontFamily: 'Gilroy',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                                  : SizedBox.shrink(), // If the condition is false, render an empty widget
                            ),
                          ],
                        ),
                         SizedBox(height: 11.h),
                        Padding(
                          padding:  EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Text(
                            latest['title'].toString(),
                            style:  TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: Color(0XFF000000),
                                fontFamily: 'Gilroy'),
                          ),
                        ),
                         SizedBox(height: 11.h),
                        Padding(
                          padding:  EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    image: NetworkImage(latest['user_pic'].toString()),
                                    height: 40.h,
                                    width: 40.w,
                                  ),

                                  SizedBox(width: 10.w),
                                  Text(
                                    latest['user_name'].toString(),
                                    style:  TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0XFF5E8421),
                                        fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              if (latest['price'] != null && latest['price'].toString() != "Rs 0.00")                              Container(
                                height: 35.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0XFFEBF2C2),
                                ),
                                child: Center(
                                    child: Text(
                                  latest['price'].toString(),
                                  style:  TextStyle(
                                      color: const Color(0XFF78A03F),
                                      fontFamily: 'Gilroy',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }



}
