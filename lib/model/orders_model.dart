import 'package:flutter/material.dart';
import 'package:workshop_app/core/utils/app_color.dart';
//import 'package:workshop_app/core/utils/assets.dart';

class OrdersModel {
  final int id; // إضافة الحقل id
  final String image;
  final String title;
  final String textType;
  final double price;
  final Color color;
  final Icon icon;

  OrdersModel({
    required this.id, // تأكد من أن id جزء من الـ constructor
    required this.image,
    required this.title,
    required this.textType,
    required this.price,
    required this.color,
    required this.icon,
  });

  // دالة لتغيير حالة الطلب
  OrdersModel changeStatus(String newStatus) {
    String newTextType;
    Color newColor;
    Icon newIcon;

    switch (newStatus) {
      case "Completed":
        newTextType = "Completed";
        newColor = Color(0xff7AFF76); // أخضر
        newIcon = Icon(Icons.done, color: AppColor.black, size: 20);
        break;
      case "Waiting":
        newTextType = "Waiting";
        newColor = Color(
          0xffF4A261,
        ); // برتقالي (تغيير اللون الأحمر إلى البرتقالي)
        newIcon = Icon(Icons.hourglass_empty, color: AppColor.black, size: 20);
        break;
      case "Failed":
        newTextType = "Failed";
        newColor = Color(0xffFF4C49); // أحمر
        newIcon = Icon(Icons.close, color: AppColor.black, size: 20);
        break;
      default:
        newTextType = "Unknown";
        newColor = Colors.grey;
        newIcon = Icon(Icons.help_outline, color: AppColor.black, size: 20);
        break;
    }

    return OrdersModel(
      id: this.id,
      image: this.image,
      title: this.title,
      price: this.price,
      textType: newTextType,
      color: newColor,
      icon: newIcon,
    );
  }
}
