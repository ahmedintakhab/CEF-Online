import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    this.borderRadius,
    this.buttonColor,
    required this.buttonText,
    this.textColor,
    this.isLoading = false, // Added loading parameter
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;
  final bool isLoading; // Loading state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap, // Disable tap when loading
      child: Container(
        height: 56,
        width: double.infinity, // Use full width of parent or set a reasonable width (e.g., 200)
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding for better spacing
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          color: buttonColor ?? const Color(0xFF78A03F),
        ),
        child: isLoading
            ? Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        )
            : Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? const Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
    );
  }
}