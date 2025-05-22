
// Widget 2: Vehicle Age Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class VehicleAgePage extends StatefulWidget {
  @override
  _VehicleAgePageState createState() => _VehicleAgePageState();
}

class _VehicleAgePageState extends State<VehicleAgePage> {
  DateTime? purchaseDate;
  DateTime? ageAtDate;
  
  String? vehicleAge;
  
  Future<void> _selectPurchaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != purchaseDate) {
      setState(() {
        purchaseDate = picked;
      });
    }
  }
  
  Future<void> _selectAgeAtDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ageAtDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != ageAtDate) {
      setState(() {
        ageAtDate = picked;
      });
    }
  }
  
  void calculateVehicleAge() {
    if (purchaseDate == null || ageAtDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select the required dates'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    if (ageAtDate!.isBefore(purchaseDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The age at date must be after the purchase date'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // حساب الفرق بين التاريخين
    int years = ageAtDate!.year - purchaseDate!.year;
    int months = ageAtDate!.month - purchaseDate!.month;
    int days = ageAtDate!.day - purchaseDate!.day;
    
    if (days < 0) {
      months--;
      days += 30; // تقريبي
    }
    
    if (months < 0) {
      years--;
      months += 12;
    }
    
    setState(() {
      vehicleAge = '$years Y, $months M, $days D';
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(' Age of Vehicle'),
          content: Text('Your vehicle age is: $vehicleAge'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Age'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Purchase Date',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => _selectPurchaseDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      purchaseDate != null 
                          ? dateFormat.format(purchaseDate!) 
                          : 'Enter purchase date (DD-MM-YYYY)',
                      style: TextStyle(
                        color: purchaseDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            Text(
              'Age at Date',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => _selectAgeAtDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ageAtDate != null 
                          ? dateFormat.format(ageAtDate!) 
                          : 'Enter age at date (DD-MM-YYYY)',
                      style: TextStyle(
                        color: ageAtDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: calculateVehicleAge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'CALCULATE VEHICLE AGE',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
