import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import '../../core/design/custom_app_bar.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';
import '../pages/cart/cart_page.dart';
import 'custom_search_delegate.dart';

class CustomSearchMain extends StatelessWidget implements PreferredSizeWidget {
  const CustomSearchMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      gradient: LinearGradient(
        colors: [
          AppColor.primary.withOpacity(.86),
          Color.fromARGB(255, 29, 196, 99),
        ],
      ),
      hideBack: true,
      height: 80.h,
      title: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                height: 48.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColor.white,
                  border: Border.all(color: AppColor.white),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search, // استخدام أيقونة البحث من مكتبة Flutter
                      color: const Color.fromARGB(
                        255,
                        61,
                        61,
                        61,
                      ), // تعيين اللون حسب الحاجة
                      size: 24.h, // تعيين الحجم
                    ),

                    horizontalSpace(10),
                    CustomTextWidget(
                      label: "Search for the product...",
                      style: TextStyleTheme.textStyleRegular,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  navigateTo(
                    toPage: BlocProvider.value(
                      value: BlocProvider.of<CartCubit>(context),
                      child: CartPage(),
                    ),
                  );
                },
                icon: Icon(CupertinoIcons.cart, color: AppColor.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
