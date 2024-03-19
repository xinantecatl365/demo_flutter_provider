import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    required this.labelText,
    required this.iconData,
    required this.keyboardType,
    this.obscureText,
    super.key,
  });

  final String labelText;
  final IconData iconData;
  final TextInputType keyboardType;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.w,
      height: 55.h,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle: TextStyle(color: Colors.blue.shade800),
          prefixIcon: Icon(iconData),
          prefixIconColor: Colors.blue,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.blue.shade200,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.blue.shade500,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
