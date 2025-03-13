import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/cart/billing_address.dart';
import '../utils/api_constants.dart';
import 'order_summary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> orderSummary = {};
  final String cartID = '';

  TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse('${ApiConstants.baseUrl}student/cartList');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            cartItems = List<Map<String, dynamic>>.from(data['data']['courses']);
            orderSummary = data['data']['order_summary'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load cart items';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load cart items: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }
// Remove the cart items
  Future<void> removeItem(int index) async {
    try {
      // Retrieve the cart_id from the cartItems list
      final cartId = cartItems[index]['cart_id'];

      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Call the delete API
      final url = Uri.parse('${ApiConstants.baseUrl}student/cart-delete/$cartId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Delete cart items API response: ${response.statusCode}');
        if (data['success'] == true) {
          // Remove the item from the cartItems list
          setState(() {
            cartItems.removeAt(index);
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to delete item';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to delete item: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }


  // void removeItem(int index) {
  //   setState(() {
  //     cartItems.removeAt(index);
  //   });
  // }

  double calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review['rating'];
    }
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                // Cart Title at top center
                Center(
                  child: Text(
                    "Cart",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF78A03F),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                if (isLoading)
                  Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F),))
                else if (errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  )
                else ...[
                    // Items count and Continue buying
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${cartItems.length} Items In Cart",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF78A03F),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle continue buying
                          },
                          child: Text(
                            "Continue Buying",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16.sp,
                              color: Color(0xFF78A03F),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Column headers
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Course",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Type",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Price",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cart Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final reviews = item['reviews'] ?? [];
                        final averageRating = calculateAverageRating(reviews);
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course (Image and Title)
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    Container(
                                      width: 120.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        image: DecorationImage(
                                          image: NetworkImage(item['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    // Title
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF000000),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),

                                    // Rating
                                    Row(
                                      children: [
                                        Text(
                                          averageRating.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0XFF000000),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Row(
                                          children: List.generate(
                                            5,
                                                (starIndex) => Icon(
                                              starIndex < averageRating.floor()
                                                  ? Icons.star
                                                  : starIndex < averageRating
                                                  ? Icons.star_half
                                                  : Icons.star_border,
                                              color: Color(0XFFFFC403),
                                              size: 18.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "(${reviews.length})",
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Type
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Course", // Placeholder type
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 16.sp,
                                      color: Color(0XFF000000),
                                    ),
                                  ),
                                ),
                              ),

                              // Price
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${item['price']} Rs",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0XFF000000),
                                    ),
                                  ),
                                ),
                              ),

                              // Remove
                              Expanded(
                                child: Center(
                                  child: IconButton(
                                    onPressed: () => removeItem(index),
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey[500],
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Coupon Code
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: TextField(
                                controller: couponController,
                                decoration: InputDecoration(
                                  hintText: "Coupon Code",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            height: 48.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Color(0xFFEBF2C2),
                            ),
                            child: Center(
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 16.sp,
                                  color: Color(0xFF78A03F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Order Summary
                    OrderSummary(
                      itemCount: orderSummary['total_items'] ?? 0,
                      totalAmount: orderSummary['total_price']?.toDouble() ?? 0.0,
                      platformCharge: orderSummary['platform_charge']?.toDouble() ?? 0.0,
                      grandTotal: orderSummary['grand_total']?.toDouble() ?? 0.0,
                    ),

                    SizedBox(height: 24.h),

                    // Buttons: Proceed to Checkout and Cancel Order
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BillingAddress()),
                              );
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: Color(0xFF78A03F),
                              ),
                              child: Center(
                                child: Text(
                                  "PROCEED TO CHECKOUT",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Color(0XFF78A03F)),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "CANCEL ORDER",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 16.sp,
                                  color: Color(0XFF78A03F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}