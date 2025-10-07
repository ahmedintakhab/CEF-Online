import 'package:flutter/material.dart';

class WelcomeBannerWidget extends StatelessWidget {
  const WelcomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image:  DecorationImage(
          image: AssetImage('assets/welcome.jpeg'), // Assume this is a dark blue wavy pattern image
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xFF0A3A75).withOpacity(0.85), // Deep navy overlay
            BlendMode.srcATop, // Keeps wave pattern visible
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome to the CEF Online Academy Ali Test 53',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Start Your Journey of Faith, Knowledge, and Character',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}