import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import '../../core/design/app_image.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/text_style_theme.dart';
import '../../model/orders_model.dart';

class OrderItem extends StatelessWidget {
  final OrdersModel model;

  const OrderItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 120.h,
      width: 313.w,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Container(
            height: 120.h,
            width: 105.w,
            decoration: BoxDecoration(color: AppColor.white),
            child: AppImage(
              model.image,
              height: 90.h,
              width: 90.h,
              fit: BoxFit.scaleDown,
            ),
          ),
          // فاصل بين الصورة والتفاصيل
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            height: 130.h,
            width: 1.w,
            color: AppColor.black,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(16),
              CustomTextWidget(
                label: model.title,
                style: TextStyleTheme.textStyle15Bold.copyWith(
                  color: AppColor.black,
                ),
              ),
              verticalSpace(5),
              CustomTextWidget(
                label: "\$${model.price}",
                style: TextStyleTheme.textStyle14Bold,
              ),
              verticalSpace(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                height: 32.h,
                width: 117.w,
                decoration: BoxDecoration(
                  color: model.color, // اللون مُحدد داخل OrdersModel
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    CustomTextWidget(
                      label: model.textType, // استخدام الحالة من `OrdersModel`
                      style: TextStyleTheme.textStyle14Regular.copyWith(
                        color: AppColor.black,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 24.h,
                      width: 24.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.black, width: 2),
                      ),
                      child: model.icon, // استخدام الأيقونة من `OrdersModel`
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
