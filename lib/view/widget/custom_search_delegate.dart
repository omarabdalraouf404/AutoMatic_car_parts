import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/service/api_service/api_service.dart';
import 'package:workshop_app/model/product_model.dart';
import 'package:workshop_app/view/widget/details_page.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';

class CustomSearchDelegate extends SearchDelegate {
  // ✅ استلام `cartItems`

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ""; // إعادة تعيين استعلام البحث
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // إغلاق الـ Search
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: ApiService.fetchProducts(), // جلب المنتجات من API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // عرض مؤشر تحميل
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching products"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products available"));
        }

        List<ProductModel> products = snapshot.data!;
        List<ProductModel> matchQuery =
            products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var product = matchQuery[index];
            return ListTile(
              title: CustomTextWidget(
                label: product.name,
                style: TextStyleTheme.textStyle13medium,
              ),
              subtitle: CustomTextWidget(
                label: "\$${product.price.toStringAsFixed(2)}",
                style: TextStyleTheme.textStyle13medium.copyWith(
                  color: AppColor.primary,
                ),
              ),
              onTap: () {
                // استخدام Cubit للوصول إلى cartItems
                final cartItems = context.read<CartCubit>().state;
                navigateTo(
                  toPage: DetailsPage(
                    product: product,
                    // cartItems: cartItems, // تمرير cartItems هنا من Cubit
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: ApiService.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching products"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products available"));
        }

        List<ProductModel> products = snapshot.data!;
        List<ProductModel> matchQuery =
            products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        return ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var product = matchQuery[index];
            return ListTile(
              title: CustomTextWidget(
                label: product.name,
                style: TextStyleTheme.textStyle13medium.copyWith(
                  color: AppColor.black,
                ),
              ),
              subtitle: CustomTextWidget(
                label: "\$${product.price.toStringAsFixed(2)}",
                style: TextStyleTheme.textStyle13medium.copyWith(
                  color: AppColor.primary,
                ),
              ),
              onTap: () {
                final cartItems = context.read<CartCubit>().state;
                navigateTo(
                  toPage: DetailsPage(
                    product: product,
                    //cartItems: cartItems, // تمرير cartItems هنا من Cubit
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
