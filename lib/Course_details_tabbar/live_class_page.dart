// live_class_page.dart
import 'package:flutter/material.dart';

class LiveClassPage extends StatelessWidget {
  const LiveClassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Live Class Page',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

