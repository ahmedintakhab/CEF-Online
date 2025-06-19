import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/cources/rating_row_widget.dart';
import 'package:learn_megnagmet/cources/review_dialog_box.dart';
import 'package:learn_megnagmet/models/riview_data.dart';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import '../controller/controller.dart';
import '../utils/screen_size.dart';

class Review extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic> reviewData;
  const Review({Key? key, required this.reviewData, required this.courseId}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  HomeController homecontroller = Get.put(HomeController());
  List<ReviewList> review = Utils.getReviewList();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    // print("Review Data on Review page: ${widget.reviewData}");
    return GetBuilder(
      init: HomeController(),
      builder: (controller) => SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text(
                    "Rating & Reviews",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Gilroy',
                        color: const Color(0XFF000000),
                    fontWeight: FontWeight.w500),
                  ),
                  Text("View All",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Gilroy',
                          color: const Color(0XFF000000))),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children:  [
                      Text(
                        widget.reviewData['average_rating']?.toString() ?? '0.0',
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 36.sp,
                            color: const Color(0XFF000000),
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "out of 5",
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 15.sp,
                            color: Color(0XFF000000),
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RatingRowWidget(
                initialRating: 5,
                itemCount: 5,
                percent: (widget.reviewData['five_star_percentage'] ?? 0) / 100,
              ),
              SizedBox(height: 10.h),
              RatingRowWidget(
                initialRating: 4,
                itemCount: 4,
                percent: (widget.reviewData['four_star_percentage'] ?? 0) / 100,
              ),
              SizedBox(height: 10.h),
              RatingRowWidget(
                initialRating: 3,
                itemCount: 3,
                percent: (widget.reviewData['three_star_percentage'] ?? 0) / 100,
              ),
              SizedBox(height: 10.h),
              RatingRowWidget(
                initialRating: 2,
                itemCount: 2,
                percent: (widget.reviewData['two_star_percentage'] ?? 0) / 100,
              ),
              SizedBox(height: 10.h),
              RatingRowWidget(
                initialRating: 1,
                itemCount: 1,
                percent: (widget.reviewData['first_star_percentage'] ?? 0) / 100,
              ),
            ],
          )
                ],
              ),
               SizedBox(height: 8.h),
               Align(
                  child: Text(
                    '${widget.reviewData['total_user_reviews']} Reviews',
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14.sp,
                        color: Color(0XFF000000),
                        fontWeight: FontWeight.normal),
                  ),
                  alignment: Alignment.centerRight),
              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(onTap: (){
                    showDialog(context: context,
                      builder: (BuildContext context){
                        return WriteReviewDialog(courseId: widget.courseId); // Pass courseID here
                    }, );
                  },
                    child:Text(
                      "Write A Review",
                      style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 18.sp,
                          color: const Color(0XFF78A03f),
                          fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF78A03F),
                        decorationThickness: 2,
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20.h,),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.reviewData['user_reviews']?.length ?? 0,
                itemBuilder: (context, index) {
                  final userReviews = widget.reviewData['user_reviews'];
                  if (userReviews == null) return const SizedBox.shrink();

                  final userReview = userReviews[index];
                  if (userReview == null) return const SizedBox.shrink();

                  return ReviewListItem(
                    userReview: userReview,
                    key: ValueKey(index), // Important for ListView optimization
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ReviewListItem extends StatefulWidget {
  final Map<String, dynamic> userReview;

  const ReviewListItem({
    Key? key,
    required this.userReview,
  }) : super(key: key);

  @override
  _ReviewListItemState createState() => _ReviewListItemState();
}

class _ReviewListItemState extends State<ReviewListItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.5.w, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.userReview['user_image'] != null
                    ? Image.network(
                  widget.userReview['user_image'].toString(),
                  height: 32.h,
                  width: 32.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 32.h,
                      width: 32.w,
                      color: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    );
                  },
                )
                    : Container(
                  height: 32.h,
                  width: 32.w,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.userReview['user_name'] != null)
                      Text(
                        widget.userReview['user_name'].toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0XFF292929),
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 4.h),
                    if (widget.userReview['comment'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userReview['comment'].toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0XFF292929),
                              fontFamily: 'Gilroy',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: isExpanded ? null : 2,
                            overflow: isExpanded
                                ? TextOverflow.clip
                                : TextOverflow.ellipsis,
                          ),
                          if (_needsReadMore(widget.userReview['comment'].toString()))
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? 'Read less' : 'Read more...',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Color(0XFF78A03F),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              if (widget.userReview['created_at'] != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    widget.userReview['created_at'].toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0XFF5E8421),
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(
            height: 1.h,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  bool _needsReadMore(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Gilroy',
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width * 0.7);
    return textPainter.didExceedMaxLines;
  }
}
//SizedBox(height: 12.h),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: widget.reviewData['user_reviews']?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final userReviews = widget.reviewData['user_reviews'];
//                   if (userReviews == null) return const SizedBox.shrink();
//
//                   final userReview = userReviews[index];
//                   if (userReview == null) return const SizedBox.shrink();
//
//                   return Padding(
//                     padding: EdgeInsets.only(left: 15.5.w, bottom: 12.h), // Added bottom padding
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(16),
//                               child: userReview['user_image'] != null
//                                   ? Image.network(
//                                 userReview['user_image'].toString(),
//                                 height: 32.h,
//                                 width: 32.w,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     height: 32.h,
//                                     width: 32.w,
//                                     color: Colors.grey[300],
//                                     child: Icon(Icons.person, color: Colors.grey[600]),
//                                   );
//                                 },
//                               )
//                                   : Container(
//                                 height: 32.h,
//                                 width: 32.w,
//                                 color: Colors.grey[300],
//                                 child: Icon(Icons.person, color: Colors.grey[600]),
//                               ),
//                             ),
//                             SizedBox(width: 15.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (userReview['user_name'] != null)
//                                     Text(
//                                       userReview['user_name'].toString(),
//                                       style: TextStyle(
//                                         fontSize: 14.sp,
//                                         color: const Color(0XFF292929),
//                                         fontFamily: 'Gilroy',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   SizedBox(height: 4.h), // Added spacing between name and comment
//                                   if (userReview['comment'] != null)
//                                     Text(
//                                       userReview['comment'].toString(),
//                                       style: TextStyle(
//                                         fontSize: 12.sp,
//                                         color: const Color(0XFF292929),
//                                         fontFamily: 'Gilroy',
//                                         fontStyle: FontStyle.normal,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                       maxLines: 3, // Limit to 3 lines
//                                       overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             if (userReview['created_at'] != null)
//                               Padding(
//                                 padding: EdgeInsets.only(top: 4.h), // Add top padding to align with name
//                                 child: Text(
//                                   userReview['created_at'].toString(),
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Color(0XFF5E8421),
//                                     fontFamily: 'Gilroy',
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         SizedBox(height: 12.h), // Add spacing between items
//                         Divider( // Add divider between reviews
//                           height: 1.h,
//                           color: Colors.grey[300],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )            ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
