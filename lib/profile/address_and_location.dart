import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cart/custom_dropdown.dart';
import '../utils/api_constants.dart';
import '../widget/custom_text_form_field.dart';

class AddressAndLocation extends StatefulWidget {
  const AddressAndLocation({Key? key}) : super(key: key);

  @override
  State<AddressAndLocation> createState() => _AddressAndLocationState();
}

class _AddressAndLocationState extends State<AddressAndLocation> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  final Map<String, int> _countryMap = {};
  final List<String> _states = ['Select state'];
  final List<String> _cities = ['Select city'];

  bool _isLoading = true;
  bool _isUpdating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCheckoutData();
  }

  Future<void> _fetchCheckoutData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}student/checkout/1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Checkout API response status code: ${response.statusCode}');

        if (data['success'] == true) {
          setState(() {
            List<dynamic> countries = data['data']['countries'];
            _countryMap.clear();
            for (var country in countries) {
              _countryMap[country['country_name']] = country['id'];
            }
            _selectedCountry = data['data']['userInfo']['country_name'] ?? null;

            _addressController.text = data['data']['userInfo']['address'] ?? '';
            _zipCodeController.text = data['data']['userInfo']['postal_code'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Failed to load data';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Request failed with status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAddress() async {
    if (_selectedCountry == null || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final url = Uri.parse("${ApiConstants.baseUrl}student/update-address-location");
      final body = jsonEncode({
        'country_id': _countryMap[_selectedCountry],
        'postal_code': _zipCodeController.text,
        'address': _addressController.text,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Address and Location API response: ${response.statusCode}');
        Get.snackbar('Address & Location','Address & Location Update Successfully',
            snackPosition: SnackPosition.BOTTOM);
        // Clear all fields after successful update
        setState(() {
          _selectedCity = null;
          _selectedCountry = null;
          _selectedState = null ;
          _addressController.clear();
          _zipCodeController.clear();
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Address and Location updated successfully')),
        // );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Failed Update Address',error['message'] , snackPosition: SnackPosition.BOTTOM);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(error['message'] ?? 'Failed to update address')),
        // );
      }
    } catch (e) {
      Get.snackbar('Failed Update Address', 'Error: $e', snackPosition: SnackPosition.BOTTOM);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }
  //
  // void _handleUpdate() {
  //   _updateAddress();
  // }

  @override
  void dispose() {
    _addressController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0XFF78A03F)))
            : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Address & Location",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                      color: Color(0XFF78A03F),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.r,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Country", true),
                      SizedBox(height: 8.h),
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search country...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Color(0xFF8CC13F), width: 2.0), // Focused border color
                              ),

                            ),
                          ),
                        ),
                        items: _countryMap.keys.toList(),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Select Country",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.grey), // Default border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Color(0xFF8CC13F), width: 2.0), // Focused border color
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountry = newValue;
                          });
                        },
                        selectedItem: _selectedCountry,
                      ),

                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("State", false),
                                SizedBox(height: 8.h),
                                CustomDropdown(
                                  hint: "Select",
                                  value: _selectedState,
                                  items: _states,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedState = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("City", false),
                                SizedBox(height: 8.h),
                                CustomDropdown(
                                  hint: "Select",
                                  value: _selectedCity,
                                  items: _cities,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCity = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildLabel("Postal Code", true),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _zipCodeController,
                        hintText: "Postal code",
                        validator: (value) => null,
                      ),
                      SizedBox(height: 16.h),
                      _buildLabel("Address", true),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _addressController,
                        hintText: "Address",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomButton(
                        onTap: _isUpdating ? () {} : _updateAddress,
                        buttonText: _isUpdating ? 'Updating...' : 'Update',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            color: const Color(0xFF000080),
          ),
        ),
        if (isRequired)
          Text(
            " *",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Gilroy',
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}