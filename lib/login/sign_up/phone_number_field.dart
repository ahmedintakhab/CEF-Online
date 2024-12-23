// phone_number_field.dart
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

Widget phone_number_field() {
  return IntlPhoneField(
    decoration: InputDecoration(
      labelText: 'Phone Number',
      labelStyle: TextStyle(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w700,
        fontSize: 15.0,
        color: Color(0XFF9B9B9B),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0XFFDEDEDE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0XFF23408F), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFFDEDEDE), width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    initialCountryCode: 'IN',
    onChanged: (phone) {
      print(phone.completeNumber);
    },
  );
}
