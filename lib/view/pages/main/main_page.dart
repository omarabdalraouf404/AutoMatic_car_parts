import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workshop_app/Cubit/cart_cupit_page.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/model/product_model.dart';
import 'package:workshop_app/model/type_cars_model.dart';
import 'package:workshop_app/service/api_service/api_service.dart';
import 'package:workshop_app/view/widget/custom_search_main.dart';
import 'package:workshop_app/view/widget/custom_top_sell_item_product.dart';
import 'package:workshop_app/view/widget/details_page.dart';
import 'package:workshop_app/view/widget/parts_item.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:workshop_app/view/widget/see_all_screen.dart';
import 'package:workshop_app/auth/login/login_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String locationText = "Delivering to...";
  loc.Location location = loc.Location();
  bool isGuest = false;
  int _currentAdIndex = 0;
  final PageController _adPageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
  }

  Future<void> _checkGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuest = prefs.getBool('isGuest') ?? false;
    });
    if (!isGuest) {
      await _loadLocation();
    } else {
      setState(() {
        locationText = "Sign in to set your location";
      });
    }
  }

  Future<void> _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('locationText');
    if (savedLocation != null) {
      setState(() {
        locationText = savedLocation;
      });
    }
  }

  Future<void> openGoogleMaps() async {
    if (isGuest) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isGuest');
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }
    try {
      var locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location data is unavailable")),
        );
        return;
      }
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      geocoding.Placemark place = placemarks[0];
      final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}',
      );
      if (await canLaunchUrl(url)) await launchUrl(url);
      setState(() {
        locationText = "Delivering to ${place.subLocality ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}";
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('locationText', locationText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get location: $e")),
      );
    }
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text("See All", style: TextStyle(fontSize: 16.sp, color: Colors.blue)),
                  SizedBox(width: 5.w),
                  Icon(Icons.arrow_forward_ios_outlined, size: 18.sp, color: Colors.blue),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: CustomSearchMain(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: openGoogleMaps,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.only(left: 16.w),
              height: 40.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 122, 213, 255).withOpacity(.86),
                    Color.fromARGB(255, 160, 255, 199),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Expanded(child: Text(locationText, overflow: TextOverflow.ellipsis)),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),

          _buildSectionHeader("Car Types", onTap: () => navigateTo(toPage: SeeAllScreen())),
          verticalSpace(5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: typeCarsList.length,
                separatorBuilder: (_, __) => horizontalSpace(16),
                itemBuilder: (_, i) => AppImage(typeCarsList[i].image, height: 100.h, width: 100.h),
              ),
            ),
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),

          _buildSectionHeader("Top Sell", onTap: () => navigateTo(toPage: SeeAllScreen())),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 230.h,
              child: BlocBuilder<CartCubit, CartState>(
                builder: (_, state) {
                  if (state is CartLoaded) {
                    return FutureBuilder<List<ProductModel>>(
                      future: ApiService.fetchProducts(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No products available"));
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (_, __) => SizedBox(width: 16.w),
                          itemBuilder: (_, i) {
                            final product = snapshot.data![i];
                            return GestureDetector(
                              onTap: () => navigateTo(toPage: DetailsPage(product: product)),
                              child: CustomTopSellItemProduct(
                                product: product,
                                cartItems: state.cart,
                                isAddedToCart: state.cart.contains(product),
                                addToCartCallback: (p) => context.read<CartCubit>().addToCart(p, context),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),

          // 🔵 إعلان سلايدر بعد Top Sell
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 180.h,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _adPageController,
                      onPageChanged: (index) => setState(() => _currentAdIndex = index),
                      children: [
                        for (var img in ['ads1.jpg', 'ads2.jpg', 'ads3.jpg'])
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/$img', fit: BoxFit.cover, width: double.infinity),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentAdIndex == i ? Colors.blue : Colors.grey,
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),

          _buildSectionHeader("Parts may you need"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FutureBuilder<List<ProductModel>>(
              future: ApiService.fetchProducts(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No products available"));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) => PartsItem(
                    product: snapshot.data![i],
                    addToCartCallback: (p) => context.read<CartCubit>().addToCart(p, context),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:workshop_app/Cubit/cart_cupit_page.dart';
// import 'package:workshop_app/Cubit/order_cubit_page.dart';
// import 'package:workshop_app/core/design/app_image.dart';
// import 'package:workshop_app/model/product_model.dart';
// import 'package:workshop_app/model/type_cars_model.dart';
// import 'package:workshop_app/service/api_service/api_service.dart';
// import 'package:workshop_app/view/widget/custom_search_main.dart';
// import 'package:workshop_app/view/widget/custom_top_sell_item_product.dart';
// import 'package:workshop_app/view/widget/details_page.dart';
// import 'package:workshop_app/view/widget/parts_item.dart';
// import 'package:workshop_app/core/design/title_text.dart';
// import 'package:workshop_app/core/utils/spacing.dart';
// import 'package:workshop_app/core/logic/helper_methods.dart';
// import 'package:location/location.dart' as loc;
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:workshop_app/view/widget/see_all_screen.dart';
// import 'package:workshop_app/auth/login/login_screen.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage>
//     with SingleTickerProviderStateMixin {
//   String locationText = "Delivering to...";
//   final loc.Location location = loc.Location();
//   bool isGuest = false;
//   int _currentAdIndex = 0;
//   final PageController _adPageController = PageController(
//     viewportFraction: 0.9,
//   );
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   Set<int> _favoriteProducts = {};
//   bool _isLoading = false;
//   final ScrollController _scrollController = ScrollController();
//   bool _showScrollToTop = false;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearchFocused = false;
//   String _searchQuery = '';
//   List<ProductModel> _filteredProducts = [];
//   String _selectedCategory = 'All';
//   RangeValues _priceRange = const RangeValues(0, 1000);
//   List<String> _categories = ['All', 'Category1', 'Category2', 'Category3'];

//   @override
//   void initState() {
//     super.initState();
//     _checkGuestStatus();
//     _loadFavorites();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//     _loadProducts();

//     _scrollController.addListener(() {
//       if (_scrollController.offset > 200 && !_showScrollToTop) {
//         setState(() => _showScrollToTop = true);
//       } else if (_scrollController.offset <= 200 && _showScrollToTop) {
//         setState(() => _showScrollToTop = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadProducts() async {
//     setState(() => _isLoading = true);
//     try {
//       final products = await ApiService.fetchProducts();
//       setState(() {
//         _filteredProducts = products;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('حدث خطأ أثناء تحميل المنتجات'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _checkGuestStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (mounted) {
//       setState(() {
//         isGuest = prefs.getBool('isGuest') ?? false;
//       });
//       if (!isGuest) {
//         await _loadLocation();
//       } else {
//         setState(() {
//           locationText = "Sign in to set your location";
//         });
//       }
//     }
//   }

//   Future<void> _loadLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedLocation = prefs.getString('locationText');
//     if (mounted && savedLocation != null) {
//       setState(() {
//         locationText = savedLocation;
//       });
//     }
//   }

//   Future<void> openGoogleMaps() async {
//     if (isGuest) {
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.remove('isGuest');
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('حدث خطأ أثناء تسجيل الدخول'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//           );
//         }
//       }
//       return;
//     }

//     try {
//       final locationData = await location.getLocation();
//       if (locationData.latitude == null || locationData.longitude == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('لم نتمكن من الحصول على موقعك الحالي'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//           );
//         }
//         return;
//       }

//       final List<geocoding.Placemark> placemarks = await geocoding
//           .placemarkFromCoordinates(
//             locationData.latitude!,
//             locationData.longitude!,
//           );

//       if (placemarks.isEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('لم نتمكن من تحديد عنوانك'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//           );
//         }
//         return;
//       }

//       final geocoding.Placemark place = placemarks[0];
//       final Uri url = Uri.parse(
//         'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}',
//       );

//       if (await canLaunchUrl(url)) {
//         await launchUrl(url);
//         if (mounted) {
//           setState(() {
//             locationText =
//                 "Delivering to ${place.subLocality ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}";
//           });
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('locationText', locationText);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('تم تحديث موقع التوصيل بنجاح'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//           );
//         }
//       } else {
//         throw 'Could not launch maps';
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('حدث خطأ أثناء فتح الخريطة: $e'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final favorites =
//         (prefs.getStringList('favorites') ?? [])
//             .map((e) => int.parse(e))
//             .toSet();
//     setState(() {
//       _favoriteProducts = favorites;
//     });
//   }

//   Future<void> _toggleFavorite(ProductModel product) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       setState(() {
//         if (_favoriteProducts.contains(product.id)) {
//           _favoriteProducts.remove(product.id);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('تمت إزالة المنتج من المفضلة'),
//               backgroundColor: Colors.blue,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         } else {
//           _favoriteProducts.add(product.id);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('تمت إضافة المنتج إلى المفضلة'),
//               backgroundColor: Colors.blue,
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       });
//       await prefs.setStringList(
//         'favorites',
//         _favoriteProducts.map((e) => e.toString()).toList(),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('حدث خطأ أثناء تحديث المفضلة'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[800],
//             ),
//           ),
//           if (onTap != null)
//             GestureDetector(
//               onTap: onTap,
//               child: Row(
//                 children: [
//                   Text(
//                     "See All",
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Colors.blue[800],
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: 5.w),
//                   Icon(
//                     Icons.arrow_forward_ios_outlined,
//                     size: 18.sp,
//                     color: Colors.blue[800],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductCard(ProductModel product, CartState state) {
//     final isFavorite = _favoriteProducts.contains(product.id);

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                   child: Image.network(
//                     product.imageUrl,
//                     height: 140.h,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _toggleFavorite(product),
//                         child: Container(
//                           padding: EdgeInsets.all(8.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             isFavorite ? Icons.favorite : Icons.favorite_border,
//                             color: isFavorite ? Colors.red : Colors.grey,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8.w,
//                           vertical: 4.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[800]!.withOpacity(0.9),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "New",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(12.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "\$${product.price}",
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue[800],
//                             ),
//                           ),
//                           Text(
//                             product.company,
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8.w,
//                           vertical: 4.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green[50],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "In Stock",
//                           style: TextStyle(
//                             color: Colors.green[700],
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12.h),
//                   ElevatedButton(
//                     onPressed: () => addToCart(product, state),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           state is CartLoaded && state.cart.contains(product)
//                               ? Colors.green[700]
//                               : Colors.blue[800],
//                       minimumSize: Size(double.infinity, 40.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           state is CartLoaded && state.cart.contains(product)
//                               ? Icons.check
//                               : Icons.shopping_cart_outlined,
//                           size: 18.sp,
//                           color: Colors.white,
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           state is CartLoaded && state.cart.contains(product)
//                               ? "Added to Cart"
//                               : "Add to Cart",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void addToCart(ProductModel product, CartState state) {
//     if (state is CartLoaded) {
//       try {
//         context.read<CartCubit>().addToCart(product, context);
//         context.read<OrdersCubit>().addOrder(product);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('تمت إضافة المنتج إلى السلة بنجاح'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('حدث خطأ أثناء إضافة المنتج إلى السلة'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   void _scrollToTop() {
//     _scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'جاري التحميل...',
//             style: TextStyle(
//               fontSize: 16.sp,
//               color: Colors.blue[800],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
//           SizedBox(height: 16.h),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 16.sp,
//               color: Colors.red,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16.h),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _isLoading = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[800],
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               'حاول مرة أخرى',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 setState(() => _searchQuery = value);
//                 _filterProducts();
//               },
//               onTap: () {
//                 setState(() => _isSearchFocused = true);
//               },
//               decoration: InputDecoration(
//                 hintText: 'ابحث عن قطع غيار السيارات...',
//                 hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Colors.blue[800],
//                   size: 24.sp,
//                 ),
//                 suffixIcon:
//                     _searchQuery.isNotEmpty
//                         ? IconButton(
//                           icon: Icon(
//                             Icons.clear,
//                             color: Colors.grey[400],
//                             size: 20.sp,
//                           ),
//                           onPressed: () {
//                             _searchController.clear();
//                             setState(() {
//                               _searchQuery = '';
//                               _filterProducts();
//                             });
//                           },
//                         )
//                         : null,
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 14.h,
//                 ),
//               ),
//             ),
//           ),
//           Container(height: 40.h, width: 1, color: Colors.grey[300]),
//           IconButton(
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => _buildFilterSheet(),
//               );
//             },
//             icon: Icon(Icons.tune, color: Colors.blue[800], size: 24.sp),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchSuggestions() {
//     if (!_isSearchFocused || _searchQuery.isEmpty) return SizedBox.shrink();

//     final suggestions =
//         _filteredProducts
//             .where(
//               (product) =>
//                   product.name.toLowerCase().contains(
//                     _searchQuery.toLowerCase(),
//                   ) ||
//                   product.description.toLowerCase().contains(
//                     _searchQuery.toLowerCase(),
//                   ),
//             )
//             .take(5)
//             .toList();

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ...suggestions.map(
//             (product) => ListTile(
//               leading: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   product.imageUrl,
//                   width: 40.w,
//                   height: 40.w,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               title: Text(
//                 product.name,
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//               ),
//               subtitle: Text(
//                 '\$${product.price}',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.blue[800],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               onTap: () {
//                 setState(() {
//                   _isSearchFocused = false;
//                   _searchController.text = product.name;
//                   _searchQuery = product.name;
//                 });
//                 _filterProducts();
//               },
//             ),
//           ),
//           if (suggestions.isEmpty)
//             Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Text(
//                 'لا توجد نتائج للبحث',
//                 style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _filterProducts() {
//     setState(() {
//       _filteredProducts =
//           _filteredProducts.where((product) {
//             bool matchesSearch =
//                 product.name.toLowerCase().contains(
//                   _searchQuery.toLowerCase(),
//                 ) ||
//                 product.description.toLowerCase().contains(
//                   _searchQuery.toLowerCase(),
//                 );
//             bool matchesPrice =
//                 product.price >= _priceRange.start &&
//                 product.price <= _priceRange.end;
//             return matchesSearch && matchesPrice;
//           }).toList();
//     });
//   }

//   Widget _buildFilterSheet() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40.w,
//             height: 4.h,
//             margin: EdgeInsets.only(bottom: 16.h),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Text(
//             'تصفية المنتجات',
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[800],
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'نطاق السعر: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
//             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//           ),
//           RangeSlider(
//             values: _priceRange,
//             min: 0,
//             max: 1000,
//             divisions: 20,
//             labels: RangeLabels(
//               '\$${_priceRange.start.round()}',
//               '\$${_priceRange.end.round()}',
//             ),
//             onChanged: (values) {
//               setState(() => _priceRange = values);
//               _filterProducts();
//             },
//           ),
//           SizedBox(height: 16.h),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _filterProducts();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[800],
//               minimumSize: Size(double.infinity, 50.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               'تطبيق التصفية',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: CustomSearchMain(),
//       body: Stack(
//         children: [
//           ListView(
//             controller: _scrollController,
//             children: [
//               // Location Bar
//               GestureDetector(
//                 onTap: openGoogleMaps,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 20.h),
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   height: 50.h,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue[400]!, Colors.blue[600]!],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.location_on, color: Colors.white),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           locationText,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Icon(Icons.keyboard_arrow_down, color: Colors.white),
//                     ],
//                   ),
//                 ),
//               ),

//               // Search Bar
//               _buildSearchBar(),
//               _buildSearchSuggestions(),

//               // Car Types Section
//               _buildSectionHeader("Car Types"),
//               verticalSpace(10),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: SizedBox(
//                   height: 120.h,
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: typeCarsList.length,
//                     separatorBuilder: (_, __) => horizontalSpace(16),
//                     itemBuilder:
//                         (_, i) => Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: AppImage(
//                             typeCarsList[i].image,
//                             height: 120.h,
//                             width: 120.h,
//                           ),
//                         ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20.h),
//               Divider(color: Colors.blue[200], thickness: 1),
//               SizedBox(height: 20.h),

//               // Top Sell Section
//               _buildSectionHeader(
//                 "Top Sell",
//                 onTap: () => navigateTo(toPage: SeeAllScreen()),
//               ),
//               SizedBox(height: 16.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: BlocBuilder<CartCubit, CartState>(
//                   builder: (_, state) {
//                     if (state is CartLoaded) {
//                       return FutureBuilder<List<ProductModel>>(
//                         future: ApiService.fetchProducts(),
//                         builder: (_, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return _buildLoadingIndicator();
//                           }
//                           if (snapshot.hasError ||
//                               !snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return _buildErrorWidget("No products available");
//                           }

//                           return GridView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 0.75,
//                                   crossAxisSpacing: 16.w,
//                                   mainAxisSpacing: 16.h,
//                                 ),
//                             itemCount: snapshot.data!.length,
//                             itemBuilder:
//                                 (_, i) => GestureDetector(
//                                   onTap:
//                                       () => navigateTo(
//                                         toPage: DetailsPage(
//                                           product: snapshot.data![i],
//                                         ),
//                                       ),
//                                   child: _buildProductCard(
//                                     snapshot.data![i],
//                                     state,
//                                   ),
//                                 ),
//                           );
//                         },
//                       );
//                     }
//                     return _buildLoadingIndicator();
//                   },
//                 ),
//               ),

//               SizedBox(height: 20.h),
//               Divider(color: Colors.blue[200], thickness: 1),
//               SizedBox(height: 20.h),

//               // Ad Slider Section
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 180.h,
//                       child: PageView(
//                         controller: _adPageController,
//                         onPageChanged:
//                             (index) => setState(() => _currentAdIndex = index),
//                         children: [
//                           for (var img in ['ads1.jpg', 'ads2.jpg', 'ads3.jpg'])
//                             Container(
//                               margin: EdgeInsets.symmetric(horizontal: 4.w),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 8,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Image.asset(
//                                   'assets/images/$img',
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         3,
//                         (i) => Container(
//                           margin: EdgeInsets.symmetric(horizontal: 4),
//                           width: 8.w,
//                           height: 8.w,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:
//                                 _currentAdIndex == i
//                                     ? Colors.blue[800]
//                                     : Colors.grey[300],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (_showScrollToTop)
//             Positioned(
//               right: 16.w,
//               bottom: 16.h,
//               child: FloatingActionButton(
//                 onPressed: _scrollToTop,
//                 backgroundColor: Colors.blue[800],
//                 child: Icon(Icons.arrow_upward, color: Colors.white),
//                 mini: true,
//               ),
//             ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: _buildLoadingIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
