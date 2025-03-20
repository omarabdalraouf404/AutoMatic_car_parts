import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/Cubit/order_cubit_page.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/view/widget/order_item.dart';
import '../../../core/design/custom_app_bar.dart';
import '../../../core/design/title_text.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/utils/text_style_theme.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
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
