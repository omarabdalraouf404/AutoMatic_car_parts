
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/view/widget/order_item.dart';
import '../../../core/design/custom_app_bar.dart';
import '../../../core/design/title_text.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
  }

  Future<void> _checkGuestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuest = prefs.getBool('isGuest') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return Scaffold(
        backgroundColor: Color(0xffDCFFF4),
        appBar: CustomAppBar(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          hideBack: true,
          title: CustomTextWidget(
            label: "Orders",
            style: TextStyleTheme.textStyle20Bold,
          ),
          gradient: LinearGradient(
            colors: [
              AppColor.primary.withOpacity(.86),
              Color.fromARGB(255, 29, 196, 99),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in now for an enjoyable experience and easy access to products.",
                  style: TextStyleTheme.textStyle15medium.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(30),
                // AppButton(
                //   text: "Sign In",
                //   textStyle: TextStyle(color: AppColor.white),
                //   onPress: () async {
                //     final prefs = await SharedPreferences.getInstance();
                //     await prefs.remove('isGuest'); // إزالة حالة الضيف
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => LoginScreen()),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffDCFFF4),
      appBar: CustomAppBar(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        hideBack: true,
        title: CustomTextWidget(
          label: "Orders",
          style: TextStyleTheme.textStyle20Bold,
        ),
        gradient: LinearGradient(
          colors: [
            AppColor.primary.withOpacity(.86),
            Color.fromARGB(255, 29, 196, 99),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
          child: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is OrdersLoaded) {
                final orders = state.orders;

                return orders.isEmpty
                    ? Center(
                      child: Text(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        "No orders yet!",
                      ),
                    )
                    : ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return OrderItem(model: orders[index]);
                      },
                      separatorBuilder: (context, index) => verticalSpace(16),
                      itemCount: orders.length,
                    );
              } else {
                return Center(child: Text("Error loading orders"));
              }
            },
          ),
        ),
  ),
);
}
}