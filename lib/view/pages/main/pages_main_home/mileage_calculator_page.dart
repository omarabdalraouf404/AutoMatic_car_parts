// Widget 3: Mileage Calculator Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MileageCalculatorPage extends StatefulWidget {
  @override
  _MileageCalculatorPageState createState() => _MileageCalculatorPageState();
}

class _MileageCalculatorPageState extends State<MileageCalculatorPage> {
  final TextEditingController fuelRateController = TextEditingController();
  final TextEditingController fuelAmountController = TextEditingController();
  final TextEditingController travelKmController = TextEditingController();
  
  double? mileageResult;
  double? costPerKm;

  void calculateMileage() {
    try {
      double fuelRate = double.parse(fuelRateController.text);
      double fuelAmount = double.parse(fuelAmountController.text);
      double travelKm = double.parse(travelKmController.text);
      
      double totalCost = fuelRate * fuelAmount;
      
      setState(() {
        mileageResult = travelKm / fuelAmount; // كم/لتر
        costPerKm = totalCost / travelKm; // تكلفة لكل كم
      });
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calculation Results'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fuel Consumption: ${mileageResult!.toStringAsFixed(2)} km/l'),
                SizedBox(height: 10),
                Text('Cost per Kilometer: ${costPerKm!.toStringAsFixed(2)} Currency Unit'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid values'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mileage Calculator'),
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
              'Fuel Rate Per Liter',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: fuelRateController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter fuel rate',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            SizedBox(height: 16.h),
            Text(
              'Total Fuel Filled Amount',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: fuelAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter total fuel filled amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            SizedBox(height: 16.h),
            Text(
              'Total Travel KM',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: travelKmController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter travel KM',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: calculateMileage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'CALCULATE MILEAGE',
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