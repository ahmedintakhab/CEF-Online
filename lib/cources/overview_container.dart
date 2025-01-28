import 'package:flutter/material.dart';

class OverviewContainer extends StatelessWidget {
  final List<Map<String, String>> items;
  final String fetchedCourseType;

  const OverviewContainer({
    Key? key,
    required this.items,
    required this.fetchedCourseType,
  }) : super(key: key);

  // Function to create each small container
  Widget buildSmallContainer(String image, String title) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      constraints: const BoxConstraints(maxWidth: 90), // Fixed width constraint
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: const Color(0XFFC7D6A7).withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 30.0,
            width: 30.0,
            color: const Color(0XFF8CC13F),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0XFF000000),
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on fetchedCourseType
    final filteredItems = fetchedCourseType == "Live"
        ? items.sublist(2) // Exclude the first two items
        : items;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // First row with up to three containers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to spaceEvenly
            children: filteredItems
                .take(3) // Safely take up to 3 items
                .map((item) => buildSmallContainer(item['image']!, item['title']!))
                .toList(),
          ),
          const SizedBox(height: 8.0),
          // Second row with remaining containers, if any
          if (filteredItems.length > 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to spaceEvenly
              children: filteredItems
                  .skip(3) // Skip the first 3 items
                  .take(3) // Take up to the next 3 items
                  .map((item) => buildSmallContainer(item['image']!, item['title']!))
                  .toList(),
            ),
        ],
      ),
    );
  }
}