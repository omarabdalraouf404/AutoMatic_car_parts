import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workshop_app/view/pages/main/pages_main_home/Car_details_page.dart';
import 'package:workshop_app/view/pages/main/pages_main_home/garages_near_me_page.dart';
import 'package:workshop_app/view/pages/main/pages_main_home/mileage_calculator_page.dart';
import 'package:workshop_app/view/pages/main/pages_main_home/vehicle_page_page.dart';

class ServiceItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const ServiceItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color: iconColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Car Info',
      'icon': Icons.directions_car,
      'backgroundColor': Colors.green,
      'iconColor': Colors.green,
    },
    {
      'title': 'Washing Center',
      'icon': Icons.local_car_wash,
      'backgroundColor': Colors.purple,
      'iconColor': Colors.purple,
    },
    {
      'title': 'Garages',
      'icon': Icons.build,
      'backgroundColor': Colors.blue,
      'iconColor': Colors.blue,
    },
    {
      'title': 'Petrol Station',
      'icon': Icons.local_gas_station,
      'backgroundColor': Colors.blue,
      'iconColor': Colors.blue,
    },
    {
      'title': 'Towing Service',
      'icon': FontAwesomeIcons.truckRampBox,
      'backgroundColor': Colors.red,
      'iconColor': Colors.red,
    },
    {
      'title': 'Mileage Calculator',
      'icon': FontAwesomeIcons.calculator,
      'backgroundColor': Colors.orange,
      'iconColor': Colors.orange,
    },
    {
      'title': 'Vehicle Age',
      'icon': FontAwesomeIcons.calendar,
      'backgroundColor': Colors.yellow,   
      'iconColor': Colors.yellow,
    },
  ];

  ServicesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle View All action
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 150.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: ServiceItem(
                  title: services[index]['title'],
                  icon: services[index]['icon'],
                  backgroundColor: services[index]['backgroundColor'],
                  iconColor: services[index]['iconColor'],
                  onTap: () {
    if (services[index]['title'] == 'Vehicle Age') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VehicleAgePage(),
        ),
      );
    } else if (services[index]['title'] == 'Mileage Calculator') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MileageCalculatorPage(),
        ),
      );
    } 
    else if (services[index]['title'] == 'Car Info') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetailsPage(),
        ),
      );
    } else if (services[index]['title'] == 'Garages') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GaragesNearMePage(),
        ),
      );
    } else {
      // لباقي الخدمات (يمكن إضافة المزيد لاحقًا)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${services[index]['title']} service selected'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


