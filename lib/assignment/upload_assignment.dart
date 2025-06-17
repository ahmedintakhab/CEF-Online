import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadAssignment extends StatefulWidget {
  const UploadAssignment({Key? key}) : super(key: key);

  @override
  _UploadAssignmentState createState() => _UploadAssignmentState();
}

class _UploadAssignmentState extends State<UploadAssignment> {
  String _fileName = 'No file chosen';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'zip'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Upload',style: TextStyle(color: Color(0xFF78A03F)),),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h,),
            Container(
              padding: const EdgeInsets.all(46.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: _pickFile,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(Icons.attach_file),
                        SizedBox(width: 8.w),
                        Text('Choose File'),
                      ],
                    ),
                  ),
                   SizedBox(height: 10.h),
                  Text(
                    _fileName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                   SizedBox(height: 10.h),
                  const Text(
                    'Accepted file selected (PDF, ZIP)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
             SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 170.w,height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Back',style: TextStyle(color: Colors.black),),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 170.w,height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add submit logic here
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                    child: const Text('SUBMIT',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}