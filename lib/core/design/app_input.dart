import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_color.dart';
import 'app_image.dart';

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText,icon;
  final bool readOnly;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextInputType? type;
  final Function(String)? onChanged;
  final double paddingBottom, paddingTop;
  final FormFieldValidator<String?>? validator;
  final Function(String)? onFieldSubmitted;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const AppInput({
    super.key,
    this.validator,
    this.controller,
    required this.hintText,
    this.paddingBottom = 16,
    this.paddingTop = 0,
    this.type,
    this.onChanged,
    this.textStyle,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.suffixIcon,
    this.readOnly = false,
    this.isPassword = false,
    required this.icon,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: widget.paddingBottom, top: widget.paddingTop),
      child: TextFormField(
        style: TextStyle(fontSize: 14.sp,color: Colors.black),
        keyboardType: widget.type,
        readOnly: widget.readOnly,
        obscureText: isPasswordHidden && widget.isPassword,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.textStyle,
          prefixIcon: AppImage(
            widget.icon,
            height: 16.h,
            width: 16.h,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.black,
                  ),
                  onPressed: () {
                    isPasswordHidden = !isPasswordHidden;
                    setState(() {});
                  },
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
