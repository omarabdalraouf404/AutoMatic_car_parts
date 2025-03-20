import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';
import 'package:workshop_app/model/product_model.dart';

class CustomCartItem extends StatelessWidget {
  final ProductModel model;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final VoidCallback onChangeStatus;

  const CustomCartItem({
    super.key,
    required this.model,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w),
      height: 130.h,
      width: 320.w,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ صورة المنتج
          Container(
            height: 120.h,
            width: 85.w,
            decoration: BoxDecoration(color: AppColor.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                model.imageUrl.isNotEmpty
                    ? model.imageUrl
                    : "https://via.placeholder.com/150",
                height: 90.h,
                width: 90.h,
                fit: BoxFit.scaleDown,
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
              ),
            ),
          ),

          // ✅ فاصل بين الصورة والتفاصيل
          Container(
            margin: EdgeInsets.only(left: 5.w, right: 10.w),
            height: 130.h,
            width: 1.w,
            color: AppColor.black,
          ),

          // ✅ تفاصيل المنتج
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(16),
              CustomTextWidget(
                label: model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleTheme.textStyle15Bold.copyWith(
                  color: AppColor.black,
                ),
              ),
              verticalSpace(5),

              // ✅ سعر المنتج
              CustomTextWidget(
                label: "\$${model.price.toStringAsFixed(2)}",
                style: TextStyleTheme.textStyle14Bold.copyWith(
                  color: Color(0xff0AA7CB), // ✅ اللون الجديد
                ),
              ),
              verticalSpace(5),

              // ✅ أزرار التحكم بالكمية + الحذف
              Row(
                children: [
                  // زر تقليل الكمية
                  Container(
                    margin: EdgeInsets.only(right: 10.w),
                    height: 29.h,
                    width: 29.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: model.amount > 1 ? Color(0xff0AA7CB) : Colors.grey,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: model.amount > 1 ? onDecrease : null,
                      icon: Icon(Icons.remove, size: 20, color: Colors.white),
                    ),
                  ),

                  // ✅ عرض الكمية
                  CustomTextWidget(
                    label: "${model.amount}",
                    style: TextStyleTheme.textStyle14Bold,
                  ),

                  // زر زيادة الكمية
                  Container(
                    margin: EdgeInsets.only(left: 10.w),
                    height: 29.h,
                    width: 29.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Color(0xff0AA7CB),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onIncrease,
                      icon: Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  ),

                  // ✅ زر حذف المنتج من السلة
                  horizontalSpace(75),
                  IconButton(
                    onPressed: onRemove, // تنفيذ دالة onRemove لحذف المنتج
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Color(0xffFF4747),
                    ),
                  ),
                  // // ✅ زر تغيير حالة المنتج
                  // IconButton(
                  //   onPressed: onChangeStatus, // تمرير onChangeStatus هنا
                  //   icon: Icon(Icons.check_circle_outline, color: Colors.green),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
