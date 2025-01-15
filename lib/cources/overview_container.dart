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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: const Color(0XFFF3F6FF),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0XFF000000),
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: filteredItems
                .take(3) // Safely take up to 3 items
                .map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: buildSmallContainer(item['image']!, item['title']!),
                ),
              );
            })
                .toList(),
          ),
          const SizedBox(height: 8.0),
          // Second row with remaining containers, if any
          if (filteredItems.length > 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: filteredItems
                  .skip(3) // Skip the first 3 items
                  .take(3) // Take up to the next 3 items
                  .map((item) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: buildSmallContainer(item['image']!, item['title']!),
                  ),
                );
              })
                  .toList(),
            ),
        ],
      ),
    );
  }
}
