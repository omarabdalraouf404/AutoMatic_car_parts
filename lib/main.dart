import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; //Provider
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/service/chat_boot/provider/msg_provider.dart';
import 'package:workshop_app/workshop_app.dart';
import 'core/logic/cache_helper.dart';
import 'Cubit/cart_cupit_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();


  // CacheHelper
  runApp(
    !kReleaseMode
        ? DevicePreview(
            enabled: true,
            builder: (context) => MyAppWithProviders(), //MultiProvider
          )
        : MyAppWithProviders(),
  );
}

class MyAppWithProviders extends StatelessWidget {
  const MyAppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()), //Provider
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