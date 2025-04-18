import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/paymob/paymob_manager.dart';
import 'package:workshop_app/view/widget/custom_cart_item.dart';
import '../../../core/design/custom_app_bar.dart';
import '../../../core/design/title_text.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/utils/spacing.dart';
import '../../../core/utils/text_style_theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
  }

  Future<void> _checkGuestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuest = prefs.getBool('isGuest') ?? false;
    });
  }

  void onPaymentSuccess(BuildContext context, int orderId) {
    context.read<OrdersCubit>().updateOrderStatus(orderId, "Completed");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment successful! Order marked as Completed.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return Scaffold(
        backgroundColor: Color(0xffDCFFF4),
        appBar: CustomAppBar(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          title: CustomTextWidget(
            label: "Cart",
            style: TextStyleTheme.textStyle20Bold,
          ),
          gradient: LinearGradient(
            colors: [
              AppColor.primary.withOpacity(.86),
              Color.fromARGB(255, 29, 196, 99),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  label: "Sign in to add items to your cart",
                  style: TextStyleTheme.textStyle15medium.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(30),
                // AppButton(
                //   text: "Sign In",
                //   textStyle: TextStyle(color: AppColor.white),
                //   buttonStyle: ElevatedButton.styleFrom(
                //     backgroundColor: AppColor.primary,
                //   ),
                //   onPress: () async {
                //     final prefs = await SharedPreferences.getInstance();
                //     await prefs.remove('isGuest');
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => LoginScreen()),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffDCFFF4),
      appBar: CustomAppBar(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        title: CustomTextWidget(
          label: "Cart",
          style: TextStyleTheme.textStyle20Bold,
        ),
        gradient: LinearGradient(
          colors: [
            AppColor.primary.withOpacity(.86),
            Color.fromARGB(255, 29, 196, 99),
          ],
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final cart = state.cart;
            double subTotal = 0.0;
            for (var item in cart) {
              subTotal += item.price * item.amount;
            }

            return SafeArea(
              child:
                  cart.isEmpty
                      ? Center(
                        child: CustomTextWidget(
                          label: "Your cart is empty!",
                          style: TextStyleTheme.textStyle16SemiBold.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                      )
                      : ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 40.h,
                        ),
                        children: [
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder:
                                (context, index) => CustomCartItem(
                                  model: cart[index],
                                  onIncrease: () {
                                    context.read<CartCubit>().updateQuantity(
                                      cart[index],
                                      true,
                                    );
                                  },
                                  onDecrease: () {
                                    context.read<CartCubit>().updateQuantity(
                                      cart[index],
                                      false,
                                    );
                                  },
                                  onRemove: () {
                                    context.read<CartCubit>().removeFromCart(
                                      cart[index],
                                    );
                                  },
                                  onChangeStatus: () {
                                    context
                                        .read<OrdersCubit>()
                                        .updateOrderStatus(
                                          cart[index].id,
                                          "Completed",
                                        );
                                  },
                                ),
                            separatorBuilder:
                                (context, index) => verticalSpace(16),
                            itemCount: cart.length,
                          ),
                          SizedBox(height: 20.h),
                          Divider(color: Colors.blue, height: 2, thickness: 1),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              CustomTextWidget(
                                label: "Sub Total",
                                style: TextStyleTheme.textStyle16SemiBold
                                    .copyWith(color: AppColor.black),
                              ),
                              Spacer(),
                              CustomTextWidget(
                                label: "\$${subTotal.toStringAsFixed(2)}",
                                style: TextStyleTheme.textStyle15Bold.copyWith(
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(5),
                          CustomTextWidget(
                            label: "(Total doesn’t include shipping)",
                            style: TextStyleTheme.textStyle14SemiBold.copyWith(
                              color: AppColor.black,
                            ),
                          ),
                          verticalSpace(16),
                          AppButton(
                            text: "Check out",
                            textStyle: TextStyleTheme.textStyle18SemiBold,
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0AA7CB),
                            ),
                            onPress: () async {
                              double subTotal = 100; // السعر الإجمالي
                              PayMobManager()
                                  .getPaymentKey(
                                    amount: subTotal,
                                    currency: "EGP",
                                    context: context,
                                  )
                                  .then((String paymentKey) {
                                    launchUrl(
                                      Uri.parse(
                                        "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey",
                                      ),
                                    ).then((_) {
                                      final cartState =
                                          context.read<CartCubit>().state;
                                      if (cartState is CartLoaded) {
                                        for (var item in cartState.cart) {
                                          onPaymentSuccess(context, item.id);
                                        }
                                      }
                                    });
                                  });
                            },
                          ),
                        ],
                      ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
    ),
);
}
}



//==========================================
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:workshop_app/Cubit/order_cubit_page.dart';
// import 'package:workshop_app/core/design/app_button.dart';
// import 'package:workshop_app/core/paymob/paymob_manager.dart';
// import 'package:workshop_app/view/widget/custom_cart_item.dart';
// import '../../../core/design/custom_app_bar.dart';
// import '../../../core/design/title_text.dart';
// import '../../../core/utils/app_color.dart';
// import '../../../core/utils/spacing.dart';
// import '../../../core/utils/text_style_theme.dart';

// class CartPage extends StatelessWidget {
//   const CartPage({super.key});

//   void onPaymentSuccess(BuildContext context, int orderId) {
//     // ✅ استدعاء OrdersCubit لتحديث الحالة إلى "Completed"
//     context.read<OrdersCubit>().updateOrderStatus(orderId, "Completed");

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment successful! Order marked as Completed.")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffDCFFF4),
//       appBar: CustomAppBar(
//         height: 50.h,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         title: CustomTextWidget(
//           label: "Cart",
//           style: TextStyleTheme.textStyle20Bold,
//         ),
//         gradient: LinearGradient(
//           colors: [
//             AppColor.primary.withOpacity(.86),
//             Color.fromARGB(255, 29, 196, 99),
//           ],
//         ),
//       ),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if (state is CartLoaded) {
//             final cart = state.cart; // الحصول على cartItems من CartLoaded
//             double subTotal = 0.0;
//             for (var item in cart) {
//               subTotal += item.price * item.amount; // حساب السعر الإجمالي
//             }

//             return SafeArea(
//               child:
//                   cart.isEmpty
//                       ? Center(
//                         child: CustomTextWidget(
//                           label: "Your cart is empty!",
//                           style: TextStyleTheme.textStyle16SemiBold.copyWith(
//                             color: AppColor.black,
//                           ),
//                         ),
//                       )
//                       : ListView(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20.w,
//                           vertical: 40.h,
//                         ),
//                         children: [
//                           ListView.separated(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemBuilder:
//                                 (context, index) => CustomCartItem(
//                                   model: cart[index],
//                                   onIncrease: () {
//                                     context.read<CartCubit>().updateQuantity(
//                                       cart[index],
//                                       true,
//                                     );
//                                   },
//                                   onDecrease: () {
//                                     context.read<CartCubit>().updateQuantity(
//                                       cart[index],
//                                       false,
//                                     );
//                                   },
//                                   onRemove: () {
//                                     context.read<CartCubit>().removeFromCart(
//                                       cart[index],
//                                     );
//                                   },
//                                   onChangeStatus: () {
//                                     // حذف استدعاء `updateOrderStatus` من CartCubit
//                                     // تحديث حالة الطلب من خلال OrdersCubit
//                                     context.read<OrdersCubit>().updateOrderStatus(
//                                       cart[index].id,
//                                       "Completed", // تغيير الحالة إلى "Completed"
//                                     );
//                                   },
//                                 ),
//                             separatorBuilder:
//                                 (context, index) => verticalSpace(16),
//                             itemCount: cart.length,
//                           ),
//                           SizedBox(height: 20.h),
//                           Divider(color: Colors.blue, height: 2, thickness: 1),
//                           SizedBox(height: 20.h),
//                           Row(
//                             children: [
//                               CustomTextWidget(
//                                 label: "Sub Total",
//                                 style: TextStyleTheme.textStyle16SemiBold
//                                     .copyWith(color: AppColor.black),
//                               ),
//                               Spacer(),
//                               CustomTextWidget(
//                                 label: "\$${subTotal.toStringAsFixed(2)}",
//                                 style: TextStyleTheme.textStyle15Bold.copyWith(
//                                   color: AppColor.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           verticalSpace(5),
//                           CustomTextWidget(
//                             label: "(Total doesn’t include shipping)",
//                             style: TextStyleTheme.textStyle14SemiBold.copyWith(
//                               color: AppColor.black,
//                             ),
//                           ),
//                           verticalSpace(16),
//                           AppButton(
//                             text: "Check out",
//                             textStyle: TextStyleTheme.textStyle18SemiBold,
//                             buttonStyle: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xff0AA7CB),
//                             ),
//                             onPress: () async {
//                               double subTotal = 100; // السعر الإجمالي

//                               PayMobManager()
//                                   .getPaymentKey(
//                                     amount: subTotal,
//                                     currency: "EGP",
//                                     context: context, // Pass the context here
//                                   )
//                                   .then((String paymentKey) {
//                                     launchUrl(
//                                       Uri.parse(
//                                         "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey",
//                                       ),
//                                     ).then((_) {
//                                       final cartState =
//                                           context.read<CartCubit>().state;
//                                       if (cartState is CartLoaded) {
//                                         for (var item in cartState.cart) {
//                                           // ✅ الآن `cart` يمكن الوصول إليه بأمان
//                                           onPaymentSuccess(context, item.id);
//                                         }
//                                       }
//                                     });
//                                   });
//                             },
//                           ),
//                         ],
//                       ),
//             );
//           } else if (state is CartLoaded) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             return Center(child: Text("Error loading cart"));
//           }
//         },
//       ),
//     );
//   }
// }
