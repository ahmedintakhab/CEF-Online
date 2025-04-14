// file_choosen_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileChoosenWidget extends StatefulWidget {
  final Function(String?) onFileSelected; // Callback to pass the file path to the parent
  final String? errorText; // To display validation error

  const FileChoosenWidget({
    Key? key,
    required this.onFileSelected,
    this.errorText,
  }) : super(key: key);

  @override
  _FileChoosenWidgetState createState() => _FileChoosenWidgetState();
}

class _FileChoosenWidgetState extends State<FileChoosenWidget> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Allow images and PDFs
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024); // Convert to MB

        // Updated logic: File should be picked only if size is <= 10 MB
        if (fileSizeInMB > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must not exceed 10 MB')),
          );
          return;
        }

        // If file size is <= 10 MB, pick the file and update the UI
        setState(() {
          _fileName = result.files.single.name;
          _filePath = result.files.single.path;
          print('Selected file name: $_fileName'); // Debug log
          print('Selected file path: $_filePath'); // Debug log
        });

        // Pass the file path to the parent widget
        widget.onFileSelected(_filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CV (Maximum File Size is 10mb)', // Updated label to reflect the new logic
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Choose File'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _fileName ?? 'No file chosen',
                  style: TextStyle(
                    color: _fileName == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}