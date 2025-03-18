import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import 'cart_screen.dart'; // Import your CartScreen

class CartCount extends StatefulWidget {
  const CartCount({Key? key}) : super(key: key);

  @override
  _CartCountState createState() => _CartCountState();
}

class _CartCountState extends State<CartCount> {
  int cartItemCount = 0; // Initialize cart item count to 0
  bool isLoading = true; // To show loading state

  @override
  void initState() {
    super.initState();
    _fetchCartCount(); // Fetch cart count when the widget is initialized
  }

  // Fetch cart count from API
  Future<void> _fetchCartCount() async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse("${ApiConstants.baseUrl}student/cart-count");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Cart count API response status code: ${response.statusCode}');
        if (data['success'] == true) {
          setState(() {
            cartItemCount = data['data']['total']; // Update cart item count
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading
          });
          throw Exception(data['message'] ?? 'Failed to fetch cart count');
        }
      } else {
        setState(() {
          isLoading = false; // Stop loading
        });
        throw Exception('Failed to fetch cart count: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading
      });
      print('Error fetching cart count: $e');
    }
  }

  // Navigate to CartScreen
  void _navigateToCartScreen() {
    Get.to(() => CartScreen()); // Navigate to CartScreen
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToCartScreen,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 30.h,
            color: Colors.black,
          ),
          if (cartItemCount > 0 && !isLoading)
            Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  '$cartItemCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (isLoading)
            Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}