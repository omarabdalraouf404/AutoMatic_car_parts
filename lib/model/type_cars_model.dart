import 'package:flutter/material.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/app_color.dart' as color;
import 'package:workshop_app/core/utils/assets.dart';

class TypeCarsModel {
  final String image;
  final Widget page;
  final String carName;

  TypeCarsModel({required this.image, required this.page, required this.carName});
}

List<TypeCarsModel> typeCarsList = [
  TypeCarsModel(image: AppImages.Mercedes, carName: 'Mercedes', page: VehicleSelectionPage(carName: 'Mercedes')),
  TypeCarsModel(image: AppImages.BMW, carName: 'BMW', page: VehicleSelectionPage(carName: 'BMW')),
  TypeCarsModel(image: AppImages.Audi, carName: 'Audi', page: VehicleSelectionPage(carName: 'Audi')),
  TypeCarsModel(image: AppImages.Fiat, carName: 'Fiat', page: VehicleSelectionPage(carName: 'Fiat')),
  TypeCarsModel(image: AppImages.Nissan, carName: 'NISSAN', page: VehicleSelectionPage(carName: 'NISSAN')),
  TypeCarsModel(image: AppImages.VloksWagen, carName: 'VolksWagen', page: VehicleSelectionPage(carName: 'VloksWagen ')),
  TypeCarsModel(image: AppImages.Honda, carName: 'HONDA', page: VehicleSelectionPage(carName: 'HONDA')),
];

class VehicleSelectionPage extends StatefulWidget {
  final String carName;
  VehicleSelectionPage({this.carName = ''});

  @override
  _VehicleSelectionPageState createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  String selectedManufacturingCountry = 'Select Country';
  String selectedEngineType = 'Select Engine Type';
  String selectedDriveType = 'Select Drive Type';
  String selectedYearRange = 'Select Year Range';

  void _navigateAndSelect(String title, List<String> items, Function(String) onSelected) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectionPage(title: title, items: items),
      ),
    );

    if (result != null) {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.carName}', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppColor.primary)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: color.AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDropdownTile('1', selectedManufacturingCountry, () {
              _navigateAndSelect('Manufacturing Countries', [
                'USA', 'Germany', 'Japan', 'South Korea', 'China', 'France', 'Italy', 'UK',
              ], (value) {
                setState(() {
                  selectedManufacturingCountry = value;
                });
              });
            }),
            SizedBox(height: 20),
            _buildDropdownTile('2', selectedEngineType, () {
              _navigateAndSelect('Engine Types', [
                'Petrol', 'Diesel', 'Electric', 'Hybrid', 'Turbocharged', 'Naturally Aspirated',
              ], (value) {
                setState(() {
                  selectedEngineType = value;
                });
              });
            }),
            SizedBox(height: 20),
            _buildDropdownTile('3', selectedDriveType, () {
              _navigateAndSelect('Drive Types', [
                'FWD (Front Wheel Drive)', 'RWD (Rear Wheel Drive)', 'AWD (All Wheel Drive)', '4WD (Four Wheel Drive)',
              ], (value) {
                setState(() {
                  selectedDriveType = value;
                });
              });
            }),
            SizedBox(height: 20),
            _buildDropdownTile('4', selectedYearRange, () {
              _navigateAndSelect('Manufacturing Year Range', [
                'Before 2000', '2000-2010', '2011-2020', '2021-Present',
              ], (value) {
                setState(() {
                  selectedYearRange = value;
                });
              });
            }),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Selected: $selectedManufacturingCountry, $selectedEngineType, $selectedDriveType, $selectedYearRange');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color.AppColor.primary,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('GO', style: TextStyle(fontSize: 20, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile(String number, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: color.AppColor.primary,  
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text('$number | ', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(width: 10),
            Expanded(
              child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class SelectionPage extends StatefulWidget {
  final String title;
  final List<String> items;

  SelectionPage({required this.title, required this.items});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    filteredItems[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, filteredItems[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





