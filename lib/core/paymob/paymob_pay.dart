import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/paymob/paymob_manager.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/view/pages/notification/notification_page.dart';
//import 'package:workshop_app/view/pages/notification/notification_page.dart';
import '../utils/text_style_theme.dart';

class PayMobPay extends StatelessWidget {
  const PayMobPay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppButton(
          text: "Pay",
          textStyle: TextStyleTheme.textStyle18SemiBold,
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0AA7CB),
          ),
          onPress: () async {
            double subTotal =
                100; // This value should be passed dynamically, depending on cart items

            // When "Check out" is pressed, PayMob page is launched
            PayMobManager()
                .getPaymentKey(
                  amount: subTotal,
                  currency: "EGP",
                  context: context, // Pass the context here
                )
                .then((String paymentKey) async {
                  // Launch PayMob Payment page
                  bool isPaymentSuccessful = await launchUrl(
                    Uri.parse(
                      "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey",
                    ),
                    mode: LaunchMode.externalApplication,
                  );

                  // Check if payment was successful based on the response
                  if (isPaymentSuccessful) {
                    // Update order status to "Completed" for all items in the cart
                    BlocProvider.of<CartCubit>(
                      context,
                    ).updateOrderStatusForAll("Completed");

                    // Add notification or order history as required
                    final cart =
                        (BlocProvider.of<CartCubit>(context).state
                                as CartLoaded)
                            .cart;
                    for (var product in cart) {
                      BlocProvider.of<CartCubit>(context).addNotification(
                        product,
                      ); // Add notification after payment
                    }

                    // Show a confirmation Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Payment Successful!")),
                    );

                    // Navigate to the Notifications Page to display the notifications
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  } else {
                    // Update order status to "Failed"
                    BlocProvider.of<CartCubit>(
                      context,
                    ).updateOrderStatusForAll("Waiting");

                    // Show a failure Snackbar
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Payment Failed!")));
                  }
                });
          },
          icon: const Icon(Icons.payment),
        ),
      ),
    );
  }
}

//=============================================
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:workshop_app/core/design/app_button.dart';
// import 'package:workshop_app/core/paymob/paymob_manager.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workshop_app/view/pages/notification/notification_page.dart';
// import '../utils/text_style_theme.dart';

// class PayMobPay extends StatelessWidget {
//   const PayMobPay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AppButton(
//           text: "Pay",
//           textStyle: TextStyleTheme.textStyle18SemiBold,
//           buttonStyle: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xff0AA7CB),
//           ),
//           onPress: () async {
//             double subTotal =
//                 100; // This value should be passed dynamically, depending on cart items

//             // When "Check out" is pressed, PayMob page is launched
//             PayMobManager()
//                 .getPaymentKey(
//                   amount: subTotal,
//                   currency: "EGP",
//                   context: context, // Pass the context here
//                 )
//                 .then((String paymentKey) async {
//                   // Launch PayMob Payment page
//                   bool isPaymentSuccessful = await launchUrl(
//                     Uri.parse(
//                       "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey",
//                     ),
//                     mode: LaunchMode.externalApplication,
//                   );

//                   // Check if payment was successful based on the response
//                   if (isPaymentSuccessful) {
//                     // Update order status to "Completed" for all items in the cart
//                     BlocProvider.of<CartCubit>(
//                       context,
//                     ).updateOrderStatusForAll("Completed");

//                     // Add notification or order history as required
//                     final cart =
//                         (BlocProvider.of<CartCubit>(context).state
//                                 as CartLoaded)
//                             .cart;
//                     for (var product in cart) {
//                       BlocProvider.of<CartCubit>(context).addNotification(
//                         product,
//                       ); // Add notification after payment
//                     }

//                     // Show a confirmation Snackbar
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Payment Successful!")),
//                     );

//                     // Navigate to the Notifications Page to display the notifications
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => NotificationPage(),
//                       ),
//                     );
//                   } else {
//                     // Update order status to "Failed"
//                     BlocProvider.of<CartCubit>(
//                       context,
//                     ).updateOrderStatusForAll("Waiting");

//                     // Show a failure Snackbar
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(SnackBar(content: Text("Payment Failed!")));
//                   }
//                 });
//           },
//         ),
//       ),
//     );
//   }
// }
