import 'package:flutter/material.dart';
import 'package:workshop_app/model/orders_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String company;
  final double price;
  final int amount;
  String status; // إضافة حالة جديدة للمنتج

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.company,
    required this.price,
    required this.amount,
    this.status = "Waiting", // الحالة الافتراضية هي "Waiting"
  });

  // دالة لتغيير الحالة
  ProductModel changeStatus(String newStatus) {
    return ProductModel(
      id: this.id,
      name: this.name,
      description: this.description,
      imageUrl: this.imageUrl,
      company: this.company,
      price: this.price,
      amount: this.amount,
      status: newStatus, // تغيير الحالة
    );
  }

  // دالة copyWith لتعديل الكائن بسهولة
  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? company,
    double? price,
    int? amount,
    String? status,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      company: company ?? this.company,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }

  // دالة لتحويل ProductModel إلى OrdersModel
  // دالة لتحويل ProductModel إلى OrdersModel
  OrdersModel toOrdersModel() {
    return OrdersModel(
      id: this.id, // تخصيص الـ id هنا
      image: this.imageUrl,
      title: this.name,
      textType: this.status, // استخدام الحالة من ProductModel
      price: this.price,
      color: this.status == "Completed" ? Colors.green : Colors.red,
      icon: Icon(
        this.status == "Completed" ? Icons.done : Icons.access_time,
        color: Colors.black,
        size: 20,
      ),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      company: json['company'],
      price: double.parse(json['price'].toString()),
      amount: int.parse(json['amount'].toString()),
      status: json['status'] ?? "Waiting", // استخدم الحالة من JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'company': company,
      'price': price,
      'amount': amount,
      'status': status,
    };
  }
}
