import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';
import 'dart:convert';

import '../../utils/api_constants.dart';

class CountriesDropdown extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final ValueChanged<int?>? onCountryIdChanged; // Callback to pass country ID

  const CountriesDropdown({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onCountryIdChanged,
  }) : super(key: key);

  @override
  _CountriesDropdownState createState() => _CountriesDropdownState();
}

class _CountriesDropdownState extends State<CountriesDropdown> {
  String? selectedValue;
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> filteredCountries = [];
  bool hasError = false;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  int? selectedCountryId;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    // Try to load from cache first
    final cachedCountries = await _getCachedCountries();
    if (cachedCountries != null && cachedCountries.isNotEmpty) {
      setState(() {
        countries = cachedCountries;
        filteredCountries = cachedCountries;
        isLoading = false;
      });
    }

    // Always try to fetch fresh data
    await _fetchCountries();
  }

  Future<List<Map<String, dynamic>>?> _getCachedCountries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('countries_list');
      if (cachedData != null) {
        return List<Map<String, dynamic>>.from(json.decode(cachedData));
      }
    } catch (e) {
      print('Error loading cached countries: $e');
    }
    return null;
  }

  Future<void> _cacheCountries(List<Map<String, dynamic>> countries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'countries_list',
        json.encode(countries),
      );
      await prefs.setInt(
        'countries_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error caching countries: $e');
    }
  }

  Future<bool> _shouldRefreshCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('countries_timestamp');
      if (timestamp == null) return true;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      return cacheAge > 24 * 60 * 60 * 1000; // Refresh if older than 24 hours
    } catch (e) {
      return true;
    }
  }

  Future<void> _fetchCountries() async {
    try {
      final shouldRefresh = await _shouldRefreshCache();
      if (!shouldRefresh && countries.isNotEmpty) return;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}frontend/get-countries-list'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final loadedCountries = jsonResponse.map<Map<String, dynamic>>((country) {
          return {
            'country_id': country['country_id'],
            'country_name': country['country_name'].toString(),
          };
        }).toList();

        await _cacheCountries(loadedCountries);

        setState(() {
          countries = loadedCountries;
          filteredCountries = loadedCountries;
          isLoading = false;
        });
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching countries: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCountries = countries
          .where((country) =>
          country['country_name'].toLowerCase().contains(query))
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
                items: filteredCountries
                    .map((Map<String, dynamic> item) => DropdownMenuItem<String>(
                  value: item['country_name'],
                  child: Text(
                    item['country_name'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                    widget.controller.text = value ?? '';
                    hasError = false;
                    state.didChange(value);
                    _searchController.text = value ?? '';
                    // Find the selected country ID
                    final selectedCountry = countries.firstWhere(
                          (country) => country['country_name'] == value,
                      orElse: () => {'country_id': null},
                    );
                    selectedCountryId = selectedCountry['country_id'] as int?;
                    // Call the callback with the selected country ID
                    if (widget.onCountryIdChanged != null) {
                      widget.onCountryIdChanged!(selectedCountryId);
                    }
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
                    child: customTextFormField(
                      controller: _searchController,
                      hintText: 'Search country...',
                      validator: (val) {},
                    ),
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