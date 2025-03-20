import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/text_style_theme.dart';

class NotificationItem extends StatelessWidget {
  final String productName;
  final String productImage;
  final String orderId;
  final DateTime time;

  const NotificationItem({
    super.key,
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      width: 380.w,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.black)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج دائرية
          Container(
            margin: EdgeInsets.only(right: 16.w, top: 7.h),
            height: 70.h,
            width: 70.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.white,
            ),
            child: ClipOval(
              // تأكيد أن الصورة تكون دائرية
              child:
                  productImage.isNotEmpty
                      ? Image.network(
                        productImage, // تحميل الصورة من الإنترنت
                        fit: BoxFit.contain, // التأكد من تغطية كامل المساحة
                        height: 70.h,
                        width: 70.h,
                      )
                      : Icon(
                        Icons.image, // أيقونة افتراضية في حالة عدم وجود صورة
                        size: 40.h, // حجم الأيقونة
                        color: AppColor.black, // اللون
                      ),
            ),
          ),
          // التفاصيل النصية
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(
                label: productName, // اسم المنتج
                style: TextStyleTheme.textStyle16SemiBold,
              ),
              CustomTextWidget(
                textAlign: TextAlign.start,
                label: "Arrived in two days, order", // نص إضافي
                style: TextStyleTheme.textStyle13medium.copyWith(
                  color: AppColor.black,
                ),
              ),
              CustomTextWidget(
                textAlign: TextAlign.start,
                label: "Number $orderId", // رقم الطلب
                style: TextStyleTheme.textStyle13medium.copyWith(
                  color: Color(0xff0AA7CB),
                ),
              ),
            ],
          ),
          // الوقت
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: CustomTextWidget(
              label:
                  "${time.hour}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}", // تنسيق الوقت
              style: TextStyleTheme.textStyle13medium.copyWith(
                color: AppColor.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
