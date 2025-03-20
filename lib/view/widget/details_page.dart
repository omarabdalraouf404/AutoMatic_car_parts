import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/design/custom_app_bar.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/model/product_model.dart'; // ✅ استبدال SparePartsModel بـ ProductModel
import '../../core/logic/helper_methods.dart';
import '../../core/utils/app_color.dart';
import '../pages/cart/cart_page.dart';

class DetailsPage extends StatefulWidget {
  final ProductModel product;

  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int amount = 1;

  void addToCart(BuildContext context) {
    context.read<CartCubit>().addToCart(
      widget.product,
      context,
    ); // ✅ تمرير `context`

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.product.name} added to cart!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomTextWidget(
          label: widget.product.name,
          style: TextStyleTheme.textStyle20Bold,
        ),
        action: IconButton(
          onPressed: () {
            navigateTo(
              toPage: BlocProvider.value(
                value: BlocProvider.of<CartCubit>(context),
                child: CartPage(),
              ),
            );
          },
          icon: Icon(CupertinoIcons.cart, color: AppColor.white),
        ),
        gradient: LinearGradient(
          colors: [
            AppColor.primary.withOpacity(.86),
            Color.fromARGB(255, 29, 196, 99),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // إضافة الـ SingleChildScrollView
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 31.w),
                height: 330.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(.86),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                ),
                child: Image.network(
                  widget.product.imageUrl.isNotEmpty
                      ? widget.product.imageUrl
                      : "https://via.placeholder.com/150",
                  height: 270.h,
                  width: 280.w,
                  fit: BoxFit.scaleDown,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 300.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 442.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 255, 247),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.r),
                    topRight: Radius.circular(35.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(30),
                    Row(
                      children: [
                        CustomTextWidget(
                          label: widget.product.name,
                          style: TextStyleTheme.textStyle17Bold,
                        ),
                        Spacer(),
                        ...List.generate(
                          5,
                          (index) => Icon(Icons.star, color: Color(0xffFCD306)),
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    Row(
                      children: [
                        CustomTextWidget(
                          label: "\$${widget.product.price}",
                          style: TextStyleTheme.textStyle17Bold,
                        ),
                        horizontalSpace(5),
                        CustomTextWidget(
                          label: "\$210",
                          style: TextStyleTheme.textStyle14Regular.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xff939393),
                          ),
                        ),
                        horizontalSpace(15),
                        Container(
                          alignment: Alignment.center,
                          height: 32.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            color: Color(0xff44C3BE),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomTextWidget(
                            label: "26% off",
                            style: TextStyleTheme.textStyle14Bold.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 10.w),
                          height: 29.h,
                          width: 29.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xff0AA7CB),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(top: 1.h),
                            onPressed: () {
                              if (amount > 1) {
                                setState(() {
                                  amount--;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 20,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        CustomTextWidget(
                          label: "$amount",
                          style: TextStyleTheme.textStyle14Bold,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          height: 29.h,
                          width: 29.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xff0AA7CB),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(top: 1.h),
                            onPressed: () {
                              setState(() {
                                amount++;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 20,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    CustomTextWidget(
                      label: "Description:",
                      style: TextStyleTheme.textStyle15Bold.copyWith(
                        color: AppColor.black,
                      ),
                    ),
                    verticalSpace(10),
                    CustomTextWidget(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      label:
                          widget.product.description.isNotEmpty
                              ? widget.product.description
                              : "No description available",
                      style: TextStyleTheme.textStyle15medium.copyWith(
                        color: Color.fromARGB(255, 50, 50, 50),
                      ),
                    ),
                    verticalSpace(10),
                    Row(
                      children: [
                        CustomTextWidget(
                          label: "Company",
                          style: TextStyleTheme.textStyle15Bold.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                        horizontalSpace(100),
                        CustomTextWidget(
                          label: "Available",
                          style: TextStyleTheme.textStyle15Bold.copyWith(
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(10),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: CustomTextWidget(
                            label:
                                widget.product.company.isNotEmpty
                                    ? widget.product.company
                                    : "Unknown",
                            style: TextStyleTheme.textStyle15medium.copyWith(
                              color: Color.fromARGB(255, 50, 50, 50),
                            ),
                          ),
                        ),
                        horizontalSpace(140),
                        CustomTextWidget(
                          label: "${widget.product.amount}",
                          style: TextStyleTheme.textStyle15medium.copyWith(
                            color: Color.fromARGB(255, 50, 50, 50),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    AppButton(
                      text: "Add to Cart",
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 147, 179),
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        fixedSize: Size(380.w, 50.h),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromARGB(255, 7, 147, 179),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPress: () async {
                        addToCart(context); // ✅ تمرير `context` عند الاستدعاء
                      },
                    ),
                    verticalSpace(10),
                    AppButton(
                      text: "Buy",
                      textStyle: TextStyle(color: AppColor.white),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 7, 147, 179),
                        fixedSize: Size(380.w, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPress: () async {}, // عملية شراء جديدة
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
