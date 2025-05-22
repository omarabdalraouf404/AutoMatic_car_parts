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
import 'package:workshop_app/view/pages/main/pages_main_home/servicesItems.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/batteriesPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/beltsPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/brakesPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/bushesPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/exhaustPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/filtersPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/pumpsPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/sensorsPage.dart';
import 'package:workshop_app/view/pages/main/widget_main_home/suspensionPage.dart';
import 'package:workshop_app/view/widget/custom_search_main.dart';
import 'package:workshop_app/view/widget/custom_top_sell_item_product.dart';
import 'package:workshop_app/view/widget/details_page.dart';
import 'package:workshop_app/view/widget/parts_item.dart';
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
  final PageController _adPageController = PageController(
    viewportFraction: 0.9,
  );

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
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Location data is unavailable")));
        return;
      }
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(
            locationData.latitude!,
            locationData.longitude!,
          );
      geocoding.Placemark place = placemarks[0];
      final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}',
      );
      if (await canLaunchUrl(url)) await launchUrl(url);
      setState(() {
        locationText =
            "Delivering to ${place.subLocality ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}";
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('locationText', locationText);
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to get location: $e")));
    }
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    "See All",
                    style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18.sp,
                    color: Colors.blue,
                  ),
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
                  Expanded(
                    child: Text(locationText, overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),

          _buildSectionHeader("Car Types"),
          verticalSpace(5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: typeCarsList.length,
                separatorBuilder: (_, __) => horizontalSpace(16),
                itemBuilder:
                    (_, i) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => typeCarsList[i].page,
                          ),
                        );
                      },
                      child: AppImage(
                        typeCarsList[i].image,
                        height: 100.h,
                        width: 100.h,
                      ),
                    ),
              ),
            ),
          ),
          verticalSpace(5),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(
                  "Main Category",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildCategoryItem(
                      context,
                      "Filters",
                      Icons.filter_alt,
                      Colors.blue,
                    ),
                    _buildCategoryItem(
                      context,
                      "Pumps",
                      Icons.local_drink,
                      Colors.teal,
                    ),
                    _buildCategoryItem(
                      context,
                      "Batteries",
                      Icons.battery_full,
                      Colors.amber,
                    ),
                    _buildCategoryItem(
                      context,
                      "Sensors",
                      Icons.sensor_door,
                      Colors.cyan,
                    ),
                    _buildCategoryItem(
                      context,
                      "Bushes",
                      Icons.safety_divider,
                      Colors.green,
                    ),
                    _buildCategoryItem(
                      context,
                      "belts",
                      Icons.directions_car,
                      Colors.red,
                    ),
                    _buildCategoryItem(
                      context,
                      "Brakes",
                      Icons.build,
                      Colors.orange,
                    ),
                    _buildCategoryItem(
                      context,
                      "Exhaust",
                      Icons.explore,
                      Colors.purple,
                    ),
                    _buildCategoryItem(
                      context,
                      "Suspension",
                      Icons.safety_check,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),

          _buildSectionHeader(
            "Top Sell",
            onTap: () => navigateTo(toPage: SeeAllScreen()),
          ),
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
                        if (snapshot.connectionState == ConnectionState.waiting)
                          // ignore: curly_braces_in_flow_control_structures
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("No products available"));
                        }
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (_, __) => SizedBox(width: 16.w),
                          itemBuilder: (_, i) {
                            final product = snapshot.data![i];
                            return GestureDetector(
                              onTap:
                                  () => navigateTo(
                                    toPage: DetailsPage(product: product),
                                  ),
                              child: CustomTopSellItemProduct(
                                product: product,
                                cartItems: state.cart,
                                isAddedToCart: state.cart.contains(product),
                                addToCartCallback:
                                    (p) => context.read<CartCubit>().addToCart(
                                      p,
                                      context,
                                    ),
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

          // 🔵 Top Sellإعلان سلايدر بعد 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 180.h,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _adPageController,
                      onPageChanged:
                          (index) => setState(() => _currentAdIndex = index),
                      children: [
                        for (var img in ['ads1.jpg', 'ads2.jpg', 'ads3.jpg'])
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/$img',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentAdIndex == i ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),
           ServicesSection(),
          SizedBox(height: 20.h),
          Divider(color: Colors.blue, thickness: 1),
          SizedBox(height: 20.h),

          _buildSectionHeader("Parts may you need"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FutureBuilder<List<ProductModel>>(
              future: ApiService.fetchProducts(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(child: Text("No products available"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder:
                      (_, i) => PartsItem(
                        product: snapshot.data![i],
                        addToCartCallback:
                            (p) =>
                                context.read<CartCubit>().addToCart(p, context),
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Widget page;

        switch (title) {
          case 'Filters':
            page = FiltersPage();
            break;
          case 'Pumps':
            page = PumpsPage();
            break;
          case 'Batteries':
            page = BatteriesPage();
            break;
          case 'Sensors':
            page = SensorsPage();
            break;
          case 'Bushes':
            page = BushesPage();
            break;
          case 'belts':
            page = BeltsPage();
            break;
          case 'Brakes':
            page = BrakesPage();
            break;
          case 'Exhaust':
            page = ExhaustPage();
            break;
          case 'Suspension':
            page = SuspensionPage();
            break;
          default:
            page = Placeholder(); // صفحة افتراضية في حالة مفيش صفحة
        }

        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        elevation: 2,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
