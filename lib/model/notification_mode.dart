import 'dart:math';

import 'package:workshop_app/model/product_model.dart';

class NotificationModel {
  final String productName;
  final String productImage;
  final String orderId;
  final DateTime time;

  NotificationModel({
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.time,
  });

  // دالة لتحويل NotificationModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productImage': productImage,
      'orderId': orderId,
      'time': time.toIso8601String(), // تحويل الوقت إلى صيغة ISO 8601
    };
  }

  // دالة لتحويل JSON إلى NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      productName: json['productName'],
      productImage: json['productImage'],
      orderId: json['orderId'],
      time: DateTime.parse(json['time']), // تحويل الوقت إلى DateTime
    );
  }

  // دالة لتحويل ProductModel إلى NotificationModel
  factory NotificationModel.fromProductModel(ProductModel product) {
    return NotificationModel(
      productName: product.name,
      productImage: product.imageUrl,
      orderId: _generateRandomOrderId(),
      time: DateTime.now(),
    );
  }

  // دالة لتوليد رقم طلب عشوائي
  static String _generateRandomOrderId() {
    final random = Random();
    return '#${random.nextInt(999999)}'; // رقم عشوائي مكون من 6 أرقام
  }
}
