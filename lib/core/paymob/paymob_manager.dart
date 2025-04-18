import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'constant.dart';

class PayMobManager {
  // original function
  Future<String> getPaymentKey({
    required double amount,
    required String currency,
    required BuildContext context, // إضافة context لتحديث حالة المنتج
  }) async {
    try {
      String authToken = await _getAuthToken();
      int orderId = await _getOrderId(
        token: authToken,
        amount: (100 * amount).toString(),
        currency: currency,
      );
      String paymentKey = await _getPaymentKey(
        token: authToken,
        currency: currency,
        amount: (100 * amount).toString(),
        orderId: orderId.toString(),
      );

      // تنفيذ الدفع
      bool isPaymentSuccessful = await _launchPayMobPaymentPage(paymentKey);

      // التحديث بناءً على حالة الدفع
      if (isPaymentSuccessful) {
        // إذا تم الدفع بنجاح
        BlocProvider.of<CartCubit>(
          context,
        ).updateOrderStatusForAll("Completed");

        // إضافة إشعار أو تاريخ الطلب كما هو مطلوب
        final cart =
            (BlocProvider.of<CartCubit>(context).state as CartLoaded).cart;
        for (var product in cart) {
          BlocProvider.of<CartCubit>(context).addNotification(product);
        }
      } else {
        // إذا فشل الدفع
        BlocProvider.of<CartCubit>(context).updateOrderStatusForAll("Failed");
      }

      return paymentKey;
    } catch (e) {
      rethrow;
    }
  }

  // دالة لإطلاق صفحة الدفع
  Future<bool> _launchPayMobPaymentPage(String paymentKey) async {
    try {
      // إطلاق صفحة الدفع الخاصة بـ PayMob
      final url =
          "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey";
      bool isPaymentSuccessful = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );

      return isPaymentSuccessful;
    } catch (e) {
      return false;
    }
  }

  // 1- getAuthToken
  Future<String> _getAuthToken() async {
    try {
      Response response = await Dio().post(
        "https://accept.paymob.com/api/auth/tokens",
        data: {"api_key": PayMobConstant.apiKey},
      );
      return response.data["token"];
    } catch (e) {
      rethrow;
    }
  }

  // 2- getOrderId
  Future<int> _getOrderId({
    required String token,
    required String amount,
    required String currency,
  }) async {
    try {
      Response response = await Dio().post(
        "https://accept.paymob.com/api/ecommerce/orders",
        data: {
          "auth_token": token,
          "delivery_needed": "false",
          "amount_cents": amount,
          "currency": currency,
          "items": [],
        },
      );
      return response.data["id"];
    } catch (e) {
      rethrow;
    }
  }

  // 3- getPaymentKey
  Future<String> _getPaymentKey({
    required String token,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    try {
      Response response = await Dio().post(
        "https://accept.paymob.com/api/acceptance/payment_keys",
        data: {
          "auth_token": token,
          "amount_cents": amount,
          "order_id": orderId,
          "currency": currency,
          "integration_id": PayMobConstant.paymentIntegration,
          "expiration": "3600",
          "billing_data": {
            "first_name": "Omar",
            "last_name": "Elgmmal",
            "email": "omarelgmmal23@gmail.com",
            "phone_number": "01062156826",
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "state": "NA",
          },
        },
      );
      return response.data["token"];
    } catch (e) {
      rethrow;
}
}
}



//''==============================================
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'constant.dart';

// class PayMobManager {
//   // original function
//   Future<String> getPaymentKey({
//     required double amount,
//     required String currency,
//     required BuildContext context, // إضافة context لتحديث حالة المنتج
//   }) async {
//     try {
//       String authToken = await _getAuthToken();
//       int orderId = await _getOrderId(
//         token: authToken,
//         amount: (100 * amount).toString(),
//         currency: currency,
//       );
//       String paymentKey = await _getPaymentKey(
//         token: authToken,
//         currency: currency,
//         amount: (100 * amount).toString(),
//         orderId: orderId.toString(),
//       );

//       // تنفيذ الدفع
//       bool isPaymentSuccessful = await _launchPayMobPaymentPage(paymentKey);

//       // التحديث بناءً على حالة الدفع
//       if (isPaymentSuccessful) {
//         // إذا تم الدفع بنجاح
//         BlocProvider.of<CartCubit>(
//           context,
//         ).updateOrderStatusForAll("Completed");

//         // إضافة إشعار أو تاريخ الطلب كما هو مطلوب
//         final cart =
//             (BlocProvider.of<CartCubit>(context).state as CartLoaded).cart;
//         for (var product in cart) {
//           BlocProvider.of<CartCubit>(context).addNotification(product);
//         }
//       } else {
//         // إذا فشل الدفع
//         BlocProvider.of<CartCubit>(context).updateOrderStatusForAll("Failed");
//       }

//       return paymentKey;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // دالة لإطلاق صفحة الدفع
//   Future<bool> _launchPayMobPaymentPage(String paymentKey) async {
//     try {
//       // إطلاق صفحة الدفع الخاصة بـ PayMob
//       final url =
//           "https://accept.paymob.com/api/acceptance/iframes/908197?payment_token=$paymentKey";
//       bool isPaymentSuccessful = await launchUrl(
//         Uri.parse(url),
//         mode: LaunchMode.externalApplication,
//       );

//       return isPaymentSuccessful;
//     } catch (e) {
//       return false;
//     }
//   }

//   // 1- getAuthToken
//   Future<String> _getAuthToken() async {
//     try {
//       Response response = await Dio().post(
//         "https://accept.paymob.com/api/auth/tokens",
//         data: {"api_key": PayMobConstant.apiKey},
//       );
//       return response.data["token"];
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // 2- getOrderId
//   Future<int> _getOrderId({
//     required String token,
//     required String amount,
//     required String currency,
//   }) async {
//     try {
//       Response response = await Dio().post(
//         "https://accept.paymob.com/api/ecommerce/orders",
//         data: {
//           "auth_token": token,
//           "delivery_needed": "false",
//           "amount_cents": amount,
//           "currency": currency,
//           "items": [],
//         },
//       );
//       return response.data["id"];
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // 3- getPaymentKey
//   Future<String> _getPaymentKey({
//     required String token,
//     required String orderId,
//     required String amount,
//     required String currency,
//   }) async {
//     try {
//       Response response = await Dio().post(
//         "https://accept.paymob.com/api/acceptance/payment_keys",
//         data: {
//           "auth_token": token,
//           "amount_cents": amount,
//           "order_id": orderId,
//           "currency": currency,
//           "integration_id": PayMobConstant.paymentIntegration,
//           "expiration": "3600",
//           "billing_data": {
//             "first_name": "Omar",
//             "last_name": "Elgmmal",
//             "email": "omarelgmmal23@gmail.com",
//             "phone_number": "01062156826",
//             "apartment": "NA",
//             "floor": "NA",
//             "street": "NA",
//             "building": "NA",
//             "shipping_method": "NA",
//             "postal_code": "NA",
//             "city": "NA",
//             "country": "NA",
//             "state": "NA",
//           },
//         },
//       );
//       return response.data["token"];
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
