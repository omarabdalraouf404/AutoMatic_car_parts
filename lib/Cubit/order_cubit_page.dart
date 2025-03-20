import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/model/product_model.dart'; // تأكد من أن هذا هو المسار الصحيح
import 'package:equatable/equatable.dart';
import 'package:workshop_app/model/orders_model.dart'; // تأكد من المسار الصحيح للـ OrdersModel

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {} // الحالة الابتدائية (لا يوجد بيانات)

class OrdersLoading
    extends OrdersState {} // حالة التحميل عندما نقوم بتحميل الطلبات

class OrdersLoaded extends OrdersState {
  final List<OrdersModel> orders; // قائمة الطلبات المحملة

  OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders]; // إضافة قائمة الطلبات كـ props
}

class OrdersError extends OrdersState {
  final String message; // رسالة الخطأ

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  // إضافة طلب إلى القائمة
  void addOrder(ProductModel product) {
    if (state is OrdersLoaded) {
      final orders = (state as OrdersLoaded).orders;
      orders.add(product.toOrdersModel()); // تحويل ProductModel إلى OrdersModel
      emit(OrdersLoaded(orders)); // تحديث الحالة بعد إضافة الطلب
    } else {
      emit(
        OrdersLoaded([product.toOrdersModel()]),
      ); // إذا كانت الحالة فارغة نضيف الطلب
    }
  }

  // إزالة طلب من القائمة
  void removeOrder(ProductModel product) {
    if (state is OrdersLoaded) {
      final orders = (state as OrdersLoaded).orders;
      orders.removeWhere(
        (order) => order.id == product.id,
      ); // إزالة الطلب بناءً على المعرف
      emit(OrdersLoaded(orders)); // تحديث الحالة بعد حذف الطلب
    }
  }

  // تحميل الطلبات من مكان تخزين مثل SharedPreferences أو API
  Future<void> loadOrders() async {
    try {
      emit(OrdersLoading()); // عند بدء التحميل
      // افترض هنا أنه يتم تحميل الطلبات من مكان تخزين (مثل API أو Local Storage)
      // سيتم استبدال هذه البيانات بمصدر البيانات الفعلي
      List<ProductModel> productOrders = []; // إضافة البيانات الفعلية هنا

      // تحويل جميع المنتج إلى OrdersModel
      List<OrdersModel> orders =
          productOrders.map((product) => product.toOrdersModel()).toList();

      // عند النجاح
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(
        OrdersError("Failed to load orders"),
      ); // في حالة حدوث خطأ أثناء التحميل
    }
  }

  void updateOrderStatus(int orderId, String newStatus) {
    if (state is OrdersLoaded) {
      final orders =
          (state as OrdersLoaded).orders.map((order) {
            if (order.id == orderId) {
              return order.changeStatus(
                newStatus,
              ); // تحديث الحالة بناءً على `newStatus`
            }
            return order;
          }).toList();

      emit(OrdersLoaded(orders)); // تحديث السلة بعد التغيير
    }
  }

  // تحميل الطلبات من مكان تخزين مثل SharedPreferences أو API
}
