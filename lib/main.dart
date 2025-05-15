import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // ✅ إضافة مكتبة Provider
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/service/chat_boot/provider/msg_provider.dart';
import 'package:workshop_app/workshop_app.dart';
import 'core/logic/cache_helper.dart';
import 'Cubit/cart_cupit_page.dart'; // ✅ تأكد من وجود هذا المسار أو عدّله حسب الحاجة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  // ✅ تعديل: دمج MultiProvider مع DevicePreview و MultiBlocProvider
  // ✅ تم إضافة هذا الكود لتهيئة الـ CacheHelper
  runApp(
    !kReleaseMode
        ? DevicePreview(
            enabled: true,
            builder: (context) => MyAppWithProviders(), // ← هنا نستخدم MultiProvider
          )
        : MyAppWithProviders(),
  );
}
// ✅ هذا الكلاس هو نقطة البداية للتطبيق
// ✅ تم إضافة MultiProvider هنا لاحتواء جميع الـ Providers
// ✅ هذا الكلاس تمت إضافته لاحتواء MultiProvider
class MyAppWithProviders extends StatelessWidget {
  const MyAppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()), // ✅ تم إضافة هذا Provider
      ],
      child: const MyAppWithBloc(),
    );
  }
}


class MyAppWithBloc extends StatelessWidget {
  const MyAppWithBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(create: (_) => CartCubit()),
        BlocProvider<OrdersCubit>(create: (_) => OrdersCubit()..loadOrders()),
      ],
      child: const WorkShopAppWithScreenUtil(),
    );
  }
}

class WorkShopAppWithScreenUtil extends StatelessWidget {
  const WorkShopAppWithScreenUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const WorkShopApp();
      },
    );
  }
}






// // import 'package:device_preview/device_preview.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; 
// import 'package:workshop_app/Cubit/order_cubit_page.dart';
// import 'package:workshop_app/workshop_app.dart';
// import 'core/logic/cache_helper.dart';
// import 'Cubit/cart_cupit_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await CacheHelper.init();
  
//   runApp(
//     !kReleaseMode
//         ? DevicePreview(
//             enabled: true,
//             builder: (context) => MyAppWithBloc(), //  DevicePreview bulit MyAppWithBloc
//           )
//         : MyAppWithBloc(),
//   );
// }

// class MyAppWithBloc extends StatelessWidget {
//   const MyAppWithBloc({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CartCubit>(create: (_) => CartCubit()),
//         BlocProvider<OrdersCubit>(
//           create: (_) => OrdersCubit()..loadOrders(),
//         ),
//       ],
//       child: const WorkShopAppWithScreenUtil(),
//     );
//   }
// }

// class WorkShopAppWithScreenUtil extends StatelessWidget {
//   const WorkShopAppWithScreenUtil({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: Size(360, 690), // size response
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return const WorkShopApp(); //real
//       },
//     );
//   }
// }



