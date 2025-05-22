import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/utils/app_color.dart' as color;

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({Key? key}) : super(key: key);

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _carDetails;

  void _searchVehicle() {
    setState(() {
      _isSearching = true;
    });

    // هنا يمكنك إضافة الكود الخاص بالبحث عن السيارة من API
    // لغرض العرض، سنقوم بمحاكاة عملية البحث
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (_vehicleNumberController.text.isNotEmpty) {
          // بيانات تجريبية للعرض فقط
          _carDetails = {
            'plateNumber': _vehicleNumberController.text,
            'make': 'Toyota',
            'model': 'Corolla',
            'year': '2022',
            'color': 'White',
            'engineType': 'Petrol',
            'transmission': 'Automatic',
            'registrationDate': '12/05/2022',
          };
        } else {
          _carDetails = null;
        }
        _isSearching = false;
      });
    });
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Car Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check Car Details',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _vehicleNumberController,
                          decoration: InputDecoration(
                            hintText: 'Enter vehicle number..',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            ),
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.blue, width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 60.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: color.AppColor.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: IconButton(
                          onPressed: _searchVehicle,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isSearching)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(30.r),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (_carDetails != null && !_isSearching)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.r),
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Plate Number', _carDetails!['plateNumber']),
                    _buildInfoRow('Make', _carDetails!['make']),
                    _buildInfoRow('Model', _carDetails!['model']),
                    _buildInfoRow('Year', _carDetails!['year']),
                    _buildInfoRow('Color', _carDetails!['color']),
                    _buildInfoRow('Engine Type', _carDetails!['engineType']),
                    _buildInfoRow('Transmission', _carDetails!['transmission']),
                    _buildInfoRow('Registration Date', _carDetails!['registrationDate']),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label + ':',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}