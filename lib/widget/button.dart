import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.onTap,
      this.borderRadius,
      this.buttonColor,
      required this.buttonText,
      this.textColor,
      Key? key})
      : super(key: key);
  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 330,
        //color: Color(0XFF23408F),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??20),
          color: buttonColor??const Color(0XFF78A03F),
        ),
        child:  Center(
          child: Text(buttonText,
              style: TextStyle(
                  color:textColor?? Color(0XFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy')),
        ),
      ),
    );
  }
}

