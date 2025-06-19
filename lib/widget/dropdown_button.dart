import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';
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
  List<String> timeZones = [];
  List<String> filteredTimeZones = [];
  bool hasError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTimeZones();
    _searchController.addListener(_filterTimeZones);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTimeZones() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}frontend/get-all-timezones'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          timeZones = jsonResponse.values.cast<String>().toList();
          filteredTimeZones = timeZones;
        });
      } else {
        print('Failed to fetch time zones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching time zones: $e');
    }
  }

  void _filterTimeZones() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTimeZones = timeZones
          .where((zone) => zone.toLowerCase().contains(query))
          .toList();
    });
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
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    color: const Color(0XFF9B9B9B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                items: filteredTimeZones
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
                    hasError = false;
                    state.didChange(value);
                    _searchController.text = value ?? '';
                  });
                },
                dropdownSearchData: DropdownSearchData(
                  searchController: _searchController,
                  searchInnerWidgetHeight: 70.h,
                  searchInnerWidget: Container(
                    height: 70.h,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: customTextFormField(controller: _searchController,
                        hintText: 'Search timezone...', validator: (val) {},),
                    // child: TextFormField(
                    //   controller: _searchController,
                    //   decoration: InputDecoration(
                    //     isDense: true,
                    //     contentPadding: const EdgeInsets.symmetric(
                    //       horizontal: 12,
                    //       vertical: 12,
                    //     ),
                    //     hintText: 'Search for timezone...',
                    //     hintStyle: const TextStyle(fontSize: 14),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide: BorderSide(
                    //         color:  Color(0xFF8CC13F), // Green border color
                    //         width: 1.5, // Slightly thicker border
                    //       ),
                    //
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide: BorderSide(
                    //         color:  Color(0XFF8CC13F), // Green border color
                    //         width: 1.5,
                    //       ),
                    //     )
                    //
                    //     ),
                    // ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value
                        .toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
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