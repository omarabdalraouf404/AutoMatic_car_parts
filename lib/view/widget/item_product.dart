
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/model/product_model.dart';

class ItemProduct extends StatefulWidget {
  final ProductModel product;
  final Function(ProductModel) addToCartCallback;

  const ItemProduct({
    super.key,
    required this.product,
    required this.addToCartCallback,
  });

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  bool isSelected = false; // للتحكم في حالة الزر

  @override
  void initState() {
    super.initState();
    // التحقق إذا كان المنتج في السلة باستخدام Cubit
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded) {
      isSelected = cartState.cart.contains(widget.product);
    }
  }

  Future<void> addToCart(BuildContext context) async {
    // فحص إذا كان المستخدم ضيف
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('isGuest') ?? false;

    if (isGuest) {
      // إظهار الـ overlay
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: AppColor.white, // خلفية بيضاء
              title: Text(
                "Sign In Required",
                style: TextStyleTheme.textStyle18medium.copyWith(
                  color:
                      AppColor
                          .black, // أسود عشان يبان (ممكن نغيّره لأبيض لو غيّرنا الخلفية)
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "You must sign in first to purchase products",
                style: TextStyleTheme.textStyle16Regular,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red), // نص Cancel أحمر
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await prefs.remove('isGuest');
                    Navigator.pop(context); // إغلاق الـ dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: AppColor.primary),
                  ),
                ),
              ],
            ),
      );
      return;
    }

    // إذا مش ضيف، أضف المنتج للسلة
    if (!isSelected) {
      context.read<CartCubit>().addToCart(widget.product, context);
      setState(() {
        isSelected = true;
      });
      // إظهار تأكيد بـ SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.product.name} added to cart!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      width: 190.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xff000000).withOpacity(.10),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Container(
                height: 140.h,
                width: 160.w,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border(
                    bottom: BorderSide(color: Color(0xffD7D7D7), width: 2),
                  ),
                ),
                child: Image.network(
                  widget.product.imageUrl.isNotEmpty
                      ? widget.product.imageUrl
                      : "https://via.placeholder.com/150",
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.fill,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50),
                ),
              ),
              verticalSpace(10),

              // اسم المنتج
              Padding(
                padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                child: CustomTextWidget(
                  label:
                      widget.product.name.isNotEmpty
                          ? widget.product.name
                          : "No Name",
                  style: TextStyleTheme.textStyle15medium,
                ),
              ),

              // السعر وزر الإضافة
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      textAlign: TextAlign.center,
                      label: "\$${widget.product.price}",
                      style: TextStyleTheme.textStyle20medium,
                    ),
                    Container(
                      height: 29.h,
                      width: 29.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xff3AB3C6), width: 3),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () => addToCart(context),
                          icon: Icon(
                            isSelected ? Icons.check : Icons.add,
                            color: Color(0xff3AB3C6),
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // النجمة في أعلى يمين العنصر
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Icon(Icons.star, size: 24, color: Color(0xffFCD306)),
          ),
        ],
    ),
);
}
}


//========================
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:workshop_app/core/design/title_text.dart';
// import 'package:workshop_app/core/utils/app_color.dart';
// import 'package:workshop_app/core/utils/text_style_theme.dart';
// import 'package:workshop_app/model/product_model.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:workshop_app/core/utils/spacing.dart';

// class ItemProduct extends StatefulWidget {
//   final ProductModel product;
//   final Function(ProductModel) addToCartCallback;

//   const ItemProduct({
//     super.key,
//     required this.product,
//     required this.addToCartCallback,
//   });

//   @override
//   State<ItemProduct> createState() => _ItemProductState();
// }

// class _ItemProductState extends State<ItemProduct> {
//   late bool isSelected; // للتحكم في حالة الزر

//   @override
//   void initState() {
//     super.initState();
//     // التحقق إذا كان المنتج في السلة باستخدام Cubit
//     final cartItems = (context.read<CartCubit>().state as CartLoaded).cart;
//     isSelected = cartItems.contains(widget.product); // تعيين حالة الزر
//   }

//   void addToCart(BuildContext context) {
//     if (!isSelected) {
//       context.read<CartCubit>().addToCart(
//         widget.product,
//         context,
//       ); // ✅ تمرير `context` عند استدعاء `addToCart`

//       setState(() {
//         isSelected = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 230.h,
//       width: 190.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.r),
//         color: AppColor.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xff000000).withOpacity(.10),
//             spreadRadius: 0,
//             blurRadius: 15,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صورة المنتج
//               Container(
//                 height: 140.h,
//                 width: 160.w,
//                 decoration: BoxDecoration(
//                   color: AppColor.white,
//                   borderRadius: BorderRadius.circular(8.r),
//                   border: Border(
//                     bottom: BorderSide(color: Color(0xffD7D7D7), width: 2),
//                   ),
//                 ),
//                 child: Image.network(
//                   widget.product.imageUrl.isNotEmpty
//                       ? widget.product.imageUrl
//                       : "https://via.placeholder.com/150",
//                   height: 100.h,
//                   width: 100.w,
//                   fit: BoxFit.fill,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           Icon(Icons.image_not_supported, size: 50),
//                 ),
//               ),
//               verticalSpace(10),

//               // اسم المنتج
//               Padding(
//                 padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
//                 child: CustomTextWidget(
//                   label:
//                       widget.product.name.isNotEmpty
//                           ? widget.product.name
//                           : "No Name",
//                   style: TextStyleTheme.textStyle15medium,
//                 ),
//               ),

//               // السعر وزر الإضافة
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomTextWidget(
//                       textAlign: TextAlign.center,
//                       label: "\$${widget.product.price}",
//                       style: TextStyleTheme.textStyle20medium,
//                     ),
//                     Container(
//                       height: 29.h,
//                       width: 29.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Color(0xff3AB3C6), width: 3),
//                       ),
//                       child: Center(
//                         child: IconButton(
//                           onPressed:
//                               () => addToCart(
//                                 context,
//                               ), // ✅ تمرير `context` عند الاستدعاء
//                           icon: Icon(
//                             isSelected ? Icons.check : Icons.add,
//                             color: Color(0xff3AB3C6),
//                             size: 18,
//                           ),
//                           padding: EdgeInsets.zero,
//                           constraints: BoxConstraints(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // النجمة في أعلى يمين العنصر
//           Positioned(
//             top: 10.h,
//             right: 10.w,
//             child: Icon(Icons.star, size: 24, color: Color(0xffFCD306)),
//           ),
//         ],
//       ),
//     );
//   }
// }
