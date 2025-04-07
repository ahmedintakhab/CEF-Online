import 'package:flutter/material.dart';
import 'individual_class_history.dart';
import 'group_class_history.dart';

class ClassHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,                    color: Color(0XFF78A03F)
        ),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IndividualClassHistory(),
            SizedBox(height: 16),
            GroupClassHistory(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}