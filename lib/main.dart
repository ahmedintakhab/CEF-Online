import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/splash/splash_screen.dart';
import 'package:learn_megnagmet/utils/custom_cache_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
   // await clearCache(); // Clear cache before the app runs
  runApp(const MyApp());
}

// Future<void> clearCache() async{
//   try{
//     await CustomCacheManager.instance.emptyCache();
//     print('🗑️ Cache cleared successfully');
//   }
//   catch(e){
//     print('❌ Error clearing cache: $e');
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent AppBar background
          elevation: 0, // Remove AppBar shadow
          titleTextStyle: TextStyle(
            color: Colors.black, // Default text color
            fontSize: 18, // Default font size
          ),
        ),
      ),
      home: const Splashscreen(),
    );
  }
}

