import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RateUsDialog extends StatelessWidget {
  final Function() onSubmit;
  final Function() onCancel;

  const RateUsDialog({
    Key? key,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  static Future<void> show({
    required Function() onSubmit,
    required Function() onCancel,
  }) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: '',
      content: RateUsDialog(
        onSubmit: onSubmit,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 42.w),
          child: Image(
            image: const AssetImage('assets/rateUs.png'),
            height: 174.h,
          ),
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 42.w),
          child: Text(
            "Give Your Opinion",
            style: TextStyle(
              fontSize: 22.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Color(0XFF000000),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Make better math goal for you, and would love to know how would rate our app?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              color: Color(0XFF000000),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        RatingBar(
          initialRating: 3,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          glow: false,
          ratingWidget: RatingWidget(
            full: Image(image: AssetImage("assets/fidbackfillicon.png")),
            half: Image(image: AssetImage("assets/fidbackemptyicon.png")),
            empty: Image(image: AssetImage("assets/fidbackemptyicon.png")),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 10),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    height: 56.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.h),
                      color: const Color(0XFF78A03F),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFFFFFFF),
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: onSubmit,
                  child: Container(
                    height: 56.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF78A03F),
                        style: BorderStyle.solid,
                        width: 1.0.w,
                      ),
                      borderRadius: BorderRadius.circular(22.h),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF78A03F),
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}