import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/instructor/student_information_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/api_constants.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({super.key});

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    String apiUrl = "${ApiConstants.baseUrl}instructor/all-students";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('All students API response: ${response.statusCode}');
        final data = jsonDecode(response.body);
        print('All students API data: $data');

        if (data['success'] == true) {
          setState(() {
            students = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load students');
        }
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        // backgroundColor: Colors.blue[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text('No students found'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text('Name', style: TextStyle(fontWeight: FontWeight.bold),

                            ),
                            SizedBox(height: 15),
                            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 25),
                            Text('Course Name', style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                            ),
                            SizedBox(height: 25),
                            Text('Enroll Date', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: student['image'] != null
                                  ? NetworkImage(student['image'])
                                  : null,
                              child: student['image'] == null
                                  ? const Icon(Icons.person, size: 20)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(student['name']),
                            const SizedBox(height: 8),
                            Text(student['email']),
                            const SizedBox(height: 4),
                            Text(student['course_title']),
                            const SizedBox(height: 8),
                            Text(student['enrolled_date']),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => StudentInformationDialog(student: student),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF78A03F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          // side: const BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                      child: const Text('VIEW', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}