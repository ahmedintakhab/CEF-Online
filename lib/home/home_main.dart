import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../My_cources/ongoing_completed_main_screen.dart';
import '../chate/chate_screen.dart';
import '../instructor/instructor_panel.dart';
import '../profile/my_profile.dart';
import '../utils/slider_page_data_model.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  // int currentvalue = 0;
  List userDetail = Utils.getUser();

  HomeMainController controller = Get.put(HomeMainController());
  String role = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roleValue = prefs.getString('role');

    print('Loaded role from SharedPreferences: $roleValue'); // Debug

    setState(() {
      role = roleValue ?? "0"; // Default to "0" if null
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeMainController>(
      init: HomeMainController(),
      builder: (controller) => Scaffold(
        body: _body(),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22), topLeft: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0XFF23408F).withOpacity(0.12),
                    spreadRadius: 0,
                    blurRadius: 12),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
              ),
              child: BottomNavigationBar(
                  backgroundColor: const Color(0XFFFFFFFF),
                  currentIndex: controller.position.value,
                  onTap: (index) {
                    // setState(() {
                    //   currentvalue = index;
                    // });
                    controller.onChange(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        activeIcon: Column(
                          children: const [
                            Image(
                                image: AssetImage("assets/bottomhomeblue.png"),
                                height: 24,
                                width: 24,
                            color: Color(0xFF8cc13f),),
                            SizedBox(height: 8.79),
                            Image(
                                image: AssetImage("assets/line.png"),
                                height: 1.75,
                                width: 24,
                              color: const Color(0xFF8CC13F),   ),
                          ],
                        ),
                        icon: const Image(
                          image: AssetImage("assets/bottomhomeblack.png"),
                          height: 24,
                          width: 24,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        activeIcon: Column(
                          children: const [
                            Image(
                                image: AssetImage("assets/bottombookblue.png"),
                                height: 24,
                                width: 24,
                                color: const Color(0xFF8CC13F),),
                            SizedBox(height: 8.79),
                            Image(
                                image: AssetImage("assets/line.png"),
                                height: 1.75,
                                width: 24,
                              color: const Color(0xFF8CC13F),),
                          ],
                        ),
                        icon: const Image(
                            image: AssetImage("assets/bottombookblack.png"),
                            height: 24,
                            width: 24),
                        label: ''),
                    // BottomNavigationBarItem(
                    //     activeIcon: Column(
                    //       children: const [
                    //         Image(
                    //             image:
                    //                 AssetImage("assets/bottommessegeblue.png"),
                    //             height: 24,
                    //             width: 24,
                    //           color: const Color(0xFF8CC13F),),
                    //         SizedBox(height: 8.79),
                    //         Image(
                    //             image: AssetImage("assets/line.png"),
                    //             height: 1.75,
                    //             width: 24,
                    //           color: const Color(0xFF8CC13F),),
                    //       ],
                    //     ),
                    //     icon: const Image(
                    //         image: AssetImage("assets/bottommessegeblack.png"),
                    //         height: 24,
                    //         width: 24),
                    //     label: ''),
                    BottomNavigationBarItem(
                        activeIcon: Column(
                          children: const [
                            Image(
                                image:
                                    AssetImage("assets/bottomprofileblue.png"),
                                height: 24,
                                width: 24,
                              color: const Color(0xFF8CC13F),),
                            SizedBox(height: 8.79),
                            Image(
                                image: AssetImage("assets/line.png"),
                                height: 1.75,
                                width: 24,
                              color: const Color(0xFF8CC13F),),
                          ],
                        ),
                        icon: const Image(
                            image: AssetImage("assets/bottomprofileblack.png"),
                            height: 24,
                            width: 24),
                        label: ''),
                  ],
                  selectedItemColor: const Color(0xFF8CC13F), // Overall selected color
              unselectedItemColor: Colors.black, // Unselected color
              ),
            )),
      ),
    );
  }

  _body() {
    switch (controller.position.value) {
      case 0:
        return HomeScreen();
      case 1:
        return const OngoingCompletedScreen();
      // case 2:
      //   return const ChateScreen();
      case 2:
      // Check the role and navigate accordingly
        if (role == '2') {
          return InstructorPanel(user_detail: userDetail[0],); // Make sure to import InstructorPanel
        } else if (role == '3') {
          return MyProfile(user_detail: userDetail[0]);
        } else {
          // Default case if role doesn't match
          return const Center(
            child: Text("Access not available for your role"),
          );
        }
      default:
        return const Center(
          child: Text("Invalid selection"),
        );
    }
  }
}
