import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/view/widget/notification_item.dart';
import '../../../core/design/custom_app_bar.dart';
import '../../../core/utils/app_color.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          padding: EdgeInsets.only(right: 16.w, left: 16.w),
          hideBack: true,
          title: CustomTextWidget(
            label: "Notifications",
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
            child: Text(
              "No notifications yet!",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffDCFFF4),
      appBar: CustomAppBar(
        height: 50.h,
        padding: EdgeInsets.only(right: 16.w, left: 16.w),
        hideBack: true,
        title: CustomTextWidget(
          label: "Notifications",
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
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              final notifications = state.notifications;

              return notifications.isEmpty
                  ? Center(
                    child: Text(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      "No notifications yet!",
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Row(
                            children: [
                              CustomTextWidget(
                                label: "New",
                                style: TextStyleTheme.textStyle18SemiBold
                                    .copyWith(color: AppColor.black),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3.h, right: 1.w),
                                margin: EdgeInsets.only(left: 20.w),
                                height: 30.h,
                                width: 30.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 97, 220, 248),
                                ),
                                child: Center(
                                  child: CustomTextWidget(
                                    textAlign: TextAlign.center,
                                    label: "${notifications.length}",
                                    style: TextStyleTheme.textStyle15medium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder:
                                (context, index) => verticalSpace(16),
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationItem(
                                productName: notification.productName,
                                productImage: notification.productImage,
                                orderId: notification.orderId,
                                time: notification.time,
                              );
                            },
                            itemCount: notifications.length,
                          ),
                        ),
                      ],
                    ),
                  );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
    ),
);
}
}

//==================================
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:workshop_app/core/design/title_text.dart';
// import 'package:workshop_app/core/utils/spacing.dart';
// import 'package:workshop_app/core/utils/text_style_theme.dart';
// import 'package:workshop_app/view/widget/notification_item.dart';
// import '../../../core/design/custom_app_bar.dart';
// import '../../../core/utils/app_color.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffDCFFF4),
//       appBar: CustomAppBar(
//         height: 50.h,
//         padding: EdgeInsets.only(right: 16.w, left: 16.w),
//         hideBack: true,
//         // action: AppImage(AppImages.notificationSvg, height: 39.h, width: 39.h),
//         title: CustomTextWidget(
//           label: "Notifications",
//           style: TextStyleTheme.textStyle20Bold,
//         ),
//         gradient: LinearGradient(
//           colors: [
//             AppColor.primary.withOpacity(.86),
//             Color.fromARGB(255, 29, 196, 99),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: BlocBuilder<CartCubit, CartState>(
//           builder: (context, state) {
//             if (state is CartLoaded) {
//               final notifications = state.notifications;

//               return notifications.isEmpty
//                   ? Center(
//                     child: Text(
//                       style: TextStyle(color: Colors.black, fontSize: 20),
//                       "No notifications yet!",
//                     ),
//                   )
//                   : Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     child: Column(
//                       children: [
//                         // عرض "New" مع عدد الإشعارات
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical: 16.h),
//                           child: Row(
//                             children: [
//                               CustomTextWidget(
//                                 label: "New",
//                                 style: TextStyleTheme.textStyle18SemiBold
//                                     .copyWith(color: AppColor.black),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.only(top: 3.h, right: 1.w),
//                                 margin: EdgeInsets.only(left: 20.w),
//                                 height: 30.h, // زيادنا الحجم قليلا
//                                 width: 30.h, // زيادنا الحجم قليلا
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color.fromARGB(255, 97, 220, 248),
//                                 ),
//                                 child: Center(
//                                   child: CustomTextWidget(
//                                     textAlign: TextAlign.center,
//                                     label: "${notifications.length}",
//                                     style: TextStyleTheme.textStyle15medium,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // قائمة الإشعارات داخل Expanded لتجنب الـ Overflow
//                         Expanded(
//                           child: ListView.separated(
//                             shrinkWrap: true,
//                             physics: AlwaysScrollableScrollPhysics(),
//                             separatorBuilder:
//                                 (context, index) => verticalSpace(16),
//                             itemBuilder: (context, index) {
//                               final notification = notifications[index];
//                               return NotificationItem(
//                                 productName: notification.productName,
//                                 productImage: notification.productImage,
//                                 orderId: notification.orderId,
//                                 time: notification.time,
//                               );
//                             },
//                             itemCount: notifications.length,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
