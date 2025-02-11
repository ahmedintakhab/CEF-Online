import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/api_constants.dart';

class DropdownButtonWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const DropdownButtonWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String? selectedValue;
  List<String> timeZones = []; // To store fetched time zones
  bool hasError = false; // Track validation state

  @override
  void initState() {
    super.initState();
    _fetchTimeZones(); // Fetch time zones when the widget is initialized
  }

  Future<void> _fetchTimeZones() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}frontend/get-all-timezones'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          timeZones = jsonResponse.values.cast<String>().toList(); // Fix for type issue
        });
      } else {
        print('Failed to fetch time zones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching time zones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  widget.hintText,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Gilroy',
                    color: const Color(0XFF9B9B9B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                items: timeZones
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                    widget.controller.text = selectedValue ?? '';
                    hasError = false; // Clear error when a value is selected
                    state.didChange(value);
                  });
                },
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasError ? Colors.red : const Color(0XFFDEDEDE),
                      width: 1,
                    ),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0XFF8CC13F),
                      width: 1,
                    ),
                    color: const Color(0xFFF5F5F5),
                  ),
                  maxHeight: 200,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
