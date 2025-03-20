import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomAppBar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    this.height,
    super.key,
    this.gradient,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: gradient,
      ),
      child: AppBar(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: 0.0,
        //centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: height ?? 50.h,
        title: title ?? const Text(''),
        titleSpacing: 0,
        actions: [action ?? Container()],
        leading:
            hideBack
                ? null
                : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColor.white,
                      border: Border.all(
                        color: Color(0xffD8DADC),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 50.h);
}
