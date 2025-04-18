
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/view/widget/details_page.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/text_style_theme.dart';
import '../../model/product_model.dart';

class PartsItem extends StatefulWidget {
  final ProductModel product;
  final Function(ProductModel) addToCartCallback;

  const PartsItem({
    super.key,
    required this.product,
    required this.addToCartCallback,
  });

  @override
  State<PartsItem> createState() => _PartsItemState();
}

class _PartsItemState extends State<PartsItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    // Check if the product is already in the cart using Cubit
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded) {
      isSelected = cartState.cart.contains(widget.product);
    }
  }

  Future<void> addToCart(BuildContext context) async {
    // Check if the user is a guest
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('isGuest') ?? false;

    if (isGuest) {
      // Show an overlay in the center of the screen
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: AppColor.white, // لون الـ dialog أبيض
              title: Text(
                "Sign In Required",
                style: TextStyleTheme.textStyle18medium.copyWith(
                  color: const Color.fromARGB(255, 0, 0, 0), // نص العنوان أبيض
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
                    style: TextStyle(
                      color: Colors.red, // نص Cancel أحمر
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('isGuest');
                    Navigator.pop(context); // إغلاق الـ dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: AppColor.primary, fontSize: 16),
                  ),
                ),
              ],
            ),
      );
      return;
    }

    // If not a guest, add the product to the cart
    if (!isSelected) {
      context.read<CartCubit>().addToCart(widget.product, context);
      setState(() {
        isSelected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.product.name} added to cart!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      width: 380.w,
      margin: EdgeInsets.only(top: 20.h),
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
      child: Row(
        children: [
          /// Product image
          GestureDetector(
            onTap: () {
              navigateTo(toPage: DetailsPage(product: widget.product));
            },
            child: Container(
              height: 130.h,
              width: 100.w,
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
                border: Border(
                  right: BorderSide(
                    color: const Color.fromARGB(255, 124, 124, 124),
                    width: 0.8,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  widget.product.imageUrl.isNotEmpty
                      ? widget.product.imageUrl
                      : "https://via.placeholder.com/150",
                  height: 130.h,
                  width: 100.w,
                  fit: BoxFit.fill,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
          ),

          /// Product details
          Expanded(
            child: GestureDetector(
              onTap: () {
                navigateTo(toPage: DetailsPage(product: widget.product));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  top: 5.h,
                  bottom: 5.h,
                  right: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      label:
                          widget.product.name.isNotEmpty
                              ? widget.product.name
                              : "No Name",
                      style: TextStyleTheme.textStyle18medium,
                    ),
                    SizedBox(height: 4.h),
                    CustomTextWidget(
                      label:
                          widget.product.description.isNotEmpty
                              ? widget.product.description
                              : "No description available",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleTheme.textStyle16Regular,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        CustomTextWidget(
                          textAlign: TextAlign.center,
                          label: "\$${widget.product.price.toStringAsFixed(2)}",
                          style: TextStyleTheme.textStyle20medium,
                        ),
                        Spacer(),

                        /// Add to cart button
                        Container(
                          height: 29.h,
                          width: 29.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xff3AB3C6),
                              width: 3,
                            ),
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
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
    ),
);
}
}

//===============================
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:workshop_app/core/logic/helper_methods.dart';
// import 'package:workshop_app/view/widget/details_page.dart';
// import '../../core/design/title_text.dart';
// import '../../core/utils/app_color.dart';
// import '../../core/utils/text_style_theme.dart';
// import '../../model/product_model.dart';

// class PartsItem extends StatefulWidget {
//   final ProductModel product;
//   final Function(ProductModel) addToCartCallback;

//   const PartsItem({
//     super.key,
//     required this.product,
//     required this.addToCartCallback,
//   });

//   @override
//   State<PartsItem> createState() => _PartsItemState();
// }

// class _PartsItemState extends State<PartsItem> {
//   bool isSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     // التحقق من إذا كان المنتج موجود في السلة باستخدام Cubit
//     final cartItems = (context.read<CartCubit>().state as CartLoaded).cart;
//     isSelected = cartItems.contains(widget.product);
//   }

//   void addToCart(BuildContext context) {
//     if (!isSelected) {
//       context.read<CartCubit>().addToCart(
//         widget.product,
//         context,
//       ); // ✅ تمرير `context`

//       setState(() {
//         isSelected = true; // ✅ تحديث الحالة بعد إضافة المنتج
//       });

//       // ✅ عرض رسالة تأكيد بعد الإضافة
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("${widget.product.name} added to cart!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130.h,
//       width: 380.w,
//       margin: EdgeInsets.only(top: 20.h),
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
//       child: Row(
//         children: [
//           /// ✅ صورة المنتج
//           GestureDetector(
//             onTap: () {
//               navigateTo(toPage: DetailsPage(product: widget.product));
//             },
//             child: Container(
//               height: 130.h,
//               width: 100.w,
//               padding: EdgeInsets.all(4.r),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8.r),
//                   bottomLeft: Radius.circular(8.r),
//                 ),
//                 border: Border(
//                   right: BorderSide(
//                     color: const Color.fromARGB(255, 124, 124, 124),
//                     width: 0.8,
//                   ),
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.r),
//                 child: Image.network(
//                   widget.product.imageUrl.isNotEmpty
//                       ? widget.product.imageUrl
//                       : "https://via.placeholder.com/150",
//                   height: 130.h,
//                   width: 100.w,
//                   fit: BoxFit.fill,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           Icon(Icons.image_not_supported, size: 50),
//                 ),
//               ),
//             ),
//           ),

//           /// ✅ تفاصيل المنتج
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 navigateTo(toPage: DetailsPage(product: widget.product));
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 16.w,
//                   top: 5.h,
//                   bottom: 5.h,
//                   right: 10,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTextWidget(
//                       label:
//                           widget.product.name.isNotEmpty
//                               ? widget.product.name
//                               : "No Name",
//                       style: TextStyleTheme.textStyle18medium,
//                     ),
//                     SizedBox(height: 4.h),
//                     CustomTextWidget(
//                       label:
//                           widget.product.description.isNotEmpty
//                               ? widget.product.description
//                               : "No description available",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyleTheme.textStyle16Regular,
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         CustomTextWidget(
//                           textAlign: TextAlign.center,
//                           label: "\$${widget.product.price.toStringAsFixed(2)}",
//                           style: TextStyleTheme.textStyle20medium,
//                         ),
//                         Spacer(),

//                         /// ✅ زر الإضافة إلى السلة
//                         Container(
//                           height: 29.h,
//                           width: 29.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Color(0xff3AB3C6),
//                               width: 3,
//                             ),
//                           ),
//                           child: Center(
//                             child: IconButton(
//                               onPressed:
//                                   () => addToCart(
//                                     context,
//                                   ), // ✅ تمرير `context` عند الاستدعاء
//                               icon: Icon(
//                                 isSelected ? Icons.check : Icons.add,
//                                 color: Color(0xff3AB3C6),
//                                 size: 18,
//                               ),
//                               padding: EdgeInsets.zero,
//                               constraints: BoxConstraints(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2.h),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
