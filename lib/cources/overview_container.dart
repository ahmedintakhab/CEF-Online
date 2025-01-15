import 'package:flutter/material.dart';

class OverviewContainer extends StatelessWidget {
  final List<Map<String, String>> items;

  const OverviewContainer({Key? key, required this.items}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // First row with three containers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(0, 3).map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: buildSmallContainer(item['image']!, item['title']!),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
          // Second row with three containers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(3, 6).map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: buildSmallContainer(item['image']!, item['title']!),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
