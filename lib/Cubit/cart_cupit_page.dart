import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/model/notification_mode.dart';
import 'package:workshop_app/model/product_model.dart';
import 'dart:convert';

// تعريف الحالات الخاصة بـ Cart
// إضافة قائمة الإشعارات إلى CartState
class CartState extends Equatable {
  final List<ProductModel> cart;
  final List<NotificationModel> notifications; // إضافة قائمة الإشعارات

  CartState({this.cart = const [], this.notifications = const []});

  @override
  List<Object> get props => [cart, notifications];
}

class CartLoaded extends CartState {
  CartLoaded(List<ProductModel> cart, List<NotificationModel> notifications)
    : super(cart: cart, notifications: notifications);
}

// إضافة حالة جديدة تُسمى OrderStatusUpdated
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartLoaded([], [])) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final cartData = prefs.getString('cart') ?? '[]';
    final List<dynamic> jsonList = json.decode(cartData);
    final List<ProductModel> cart =
        jsonList.map((item) => ProductModel.fromJson(item)).toList();

    // تحميل حالة كل منتج من SharedPreferences
    for (var product in cart) {
      String? status = prefs.getString('status_${product.id}');
      if (status != null) {
        product.status = status; // تحديث حالة المنتج بناءً على القيمة المخزنة
      }
    }

    emit(CartLoaded(cart, [])); // تحديث حالة السلة والإشعارات
  }

  // حفظ السلة في SharedPreferences
  Future<void> _saveCart(List<ProductModel> cart) async {
    final prefs = await SharedPreferences.getInstance();

    // حفظ بيانات السلة بشكل كامل
    final cartData = json.encode(cart.map((item) => item.toJson()).toList());
    await prefs.setString('cart', cartData);

    // حفظ حالة كل منتج في SharedPreferences
    for (var product in cart) {
      await prefs.setString(
        'status_${product.id}',
        product.status,
      ); // حفظ الحالة بناءً على ID المنتج
    }
  }

  // إضافة منتج إلى السلة
  void addToCart(ProductModel product, BuildContext context) {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;

      if (!currentCart.contains(product)) {
        final updatedCart = List<ProductModel>.from(currentCart)..add(product);
        _saveCart(updatedCart); // حفظ السلة بعد التعديل
        emit(
          CartLoaded(updatedCart, (state as CartLoaded).notifications),
        ); // تحديث حالة السلة مع الإشعارات

        // ✅ إضافة المنتج إلى OrdersCubit أيضًا
        context.read<OrdersCubit>().addOrder(product);
      }
    }
  }

  // إزالة منتج من السلة
  void removeFromCart(ProductModel product) {
    if (state is CartLoaded) {
      final updatedCart = List<ProductModel>.from((state as CartLoaded).cart);
      updatedCart.remove(product);
      _saveCart(updatedCart); // حفظ السلة بعد التعديل
      emit(
        CartLoaded(updatedCart, (state as CartLoaded).notifications),
      ); // تحديث حالة السلة
    }
  }

  // تحديث الكمية
  void updateQuantity(ProductModel product, bool isAdding) {
    if (state is CartLoaded) {
      final updatedCart = List<ProductModel>.from((state as CartLoaded).cart);
      final index = updatedCart.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        final newAmount =
            isAdding
                ? updatedCart[index].amount + 1
                : (updatedCart[index].amount > 1
                    ? updatedCart[index].amount - 1
                    : updatedCart[index].amount);
        updatedCart[index] = updatedCart[index].copyWith(amount: newAmount);
        _saveCart(updatedCart); // حفظ السلة بعد التعديل
        emit(
          CartLoaded(updatedCart, (state as CartLoaded).notifications),
        ); // تحديث حالة السلة
      }
    }
  }

  // إضافة إشعار جديد بعد إتمام الدفع
  void addNotification(ProductModel product) {
    final randomOrderId = _generateRandomOrderId(); // توليد رقم طلب عشوائي
    final notification = NotificationModel(
      productName: product.name,
      productImage: product.imageUrl,
      orderId: randomOrderId,
      time: DateTime.now(),
    );

    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final updatedNotifications = List<NotificationModel>.from(
        currentState.notifications,
      )..add(notification);

      // هنا يجب أن نتأكد من أنه يتم تخزين الإشعارات في SharedPreferences أيضًا
      _saveNotifications(updatedNotifications);

      emit(
        CartLoaded(currentState.cart, updatedNotifications),
      ); // تحديث الحالة مع الإشعارات الجديدة
    }
  }

  // دالة لحفظ الإشعارات في SharedPreferences
  Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsData = json.encode(
      notifications.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(
      'notifications',
      notificationsData,
    ); // حفظ الإشعارات في SharedPreferences
  }

  // تحميل الإشعارات من SharedPreferences
  // ignore: unused_element
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsData = prefs.getString('notifications') ?? '[]';
    final List<dynamic> jsonList = json.decode(notificationsData);
    final List<NotificationModel> notifications =
        jsonList.map((item) => NotificationModel.fromJson(item)).toList();

    emit(CartLoaded([], notifications)); // تحديث الحالة مع الإشعارات المحملة
  }

  // تحديث حالة المنتج
  // void updateOrderStatus(int index, String status) {
  //   if (state is CartLoaded) {
  //     final updatedCart = List<ProductModel>.from((state as CartLoaded).cart);
  //     updatedCart[index] = updatedCart[index].copyWith(status: status);
  //     _saveCart(updatedCart); // حفظ السلة بعد التعديل
  //     emit(
  //       CartLoaded(updatedCart, (state as CartLoaded).notifications),
  //     ); // تحديث حالة السلة مع الإشعارات
  //   }
  // }

  // تحديث حالة جميع المنتجات في السلة
  void updateOrderStatusForAll(String status) {
    if (state is CartLoaded) {
      final updatedCart = List<ProductModel>.from((state as CartLoaded).cart);

      for (int i = 0; i < updatedCart.length; i++) {
        updatedCart[i] = updatedCart[i].copyWith(
          status: status, // تحديث الحالة لكل منتج
        );
      }

      _saveCart(updatedCart); // حفظ السلة بعد التعديل
      emit(
        CartLoaded(updatedCart, (state as CartLoaded).notifications),
      ); // تحديث الـ state مع السلة المحدثة
    }
  }

  // دالة لتوليد رقم طلب عشوائي
  String _generateRandomOrderId() {
    final random = Random();
    return '#${random.nextInt(999999)}';
  }
}
