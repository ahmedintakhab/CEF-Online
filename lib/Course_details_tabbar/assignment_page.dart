import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/assignment/assignment_details.dart';
import 'package:learn_megnagmet/assignment/assignment_result.dart';

class AssignmentPage extends StatelessWidget {
  final List<dynamic> assignmentData;

  const AssignmentPage({Key? key, required this.assignmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assignmentData.length,
      itemBuilder: (context, index) {
        final assignment = assignmentData[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Assignment Topic',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(assignment['assignment_topic']),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Marks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${assignment['assignment_total_marks']}'),
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      navigator?.push(MaterialPageRoute(builder: (context)=>AssignmentDetails()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                    child: const Text('VIEW DETAILS',style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 18.0),
                  ElevatedButton(
                    onPressed: () {
                      navigator?.push(MaterialPageRoute(builder: (context)=>AssignmentResult()));

                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                    child: const Text('SEE RESULT', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
