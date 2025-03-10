import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/cart/billing_address.dart';
import 'order_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample data for cart items
  List<Map<String, dynamic>> cartItems = [
    {
      'id': 1,
      'title': '25 Character Workshops for Grade 6 to 12: Building Leaders of Tomorrow',
      'image': 'https://cef.org.pk/shop/wp-content/uploads/2024/03/CEF-Beginner-300x300.webp', // Replace with actual image URL
      'price': '4999.00',
      'type': 'Course',
      'star_rating': 4.3,
      'rating_count': 3,
      'duration': 30,
    },

    // Add more items if needed
  ];

  TextEditingController couponController = TextEditingController();

  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += double.parse(item['price'].toString());
    }
    return total;
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
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
                SizedBox(height: 30,),
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

                // Items count and Continue buying
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${cartItems.length} Items In Card",
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
                                      "${item['star_rating']}",
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
                                          starIndex < (item['star_rating'] ?? 0).floor()
                                              ? Icons.star
                                              : starIndex < (item['star_rating'] ?? 0)
                                              ? Icons.star_half
                                              : Icons.star_border,
                                          color: Color(0XFFFFC403),
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "(${item['rating_count'] ?? 0})",
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
                                item['type'],
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
                  itemCount: cartItems.length,
                  totalAmount: calculateTotal(),
                ),

                SizedBox(height: 24.h),

                // Buttons: Proceed to Checkout and Cancel Order
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BillingAddress()));
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
            ),
          ),
        ),
      ),
    );
  }
}