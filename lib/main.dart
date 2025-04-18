import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // استيراد Bloc
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/workshop_app.dart';
import 'core/logic/cache_helper.dart';
import 'Cubit/cart_cupit_page.dart'; // استيراد CartCubit
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  runApp(
    !kReleaseMode
        ? DevicePreview(
          enabled: true,
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<CartCubit>(create: (_) => CartCubit()),
                  BlocProvider<OrdersCubit>(
                    create:
                        (_) =>
                            OrdersCubit()
                              ..loadOrders(), // تأكد من استدعاء loadOrders()
                  ),
                ],
                child: const WorkShopApp(),
              ),
        )
        : MultiBlocProvider(
          providers: [
            BlocProvider<CartCubit>(create: (_) => CartCubit()),
            BlocProvider<OrdersCubit>(
              create:
                  (_) =>
                      OrdersCubit()
                        ..loadOrders(), // إضافة OrdersCubit هنا أيضًا
            ),
          ],
          child: const WorkShopApp(),
        ),
  );
}
