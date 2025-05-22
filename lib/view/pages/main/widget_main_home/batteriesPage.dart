import 'package:flutter/material.dart';

class BatteriesPage extends StatelessWidget {
  final List<Map<String, String>> batteries = [
    {'name': 'Oil Battery', 'image': 'assets/images/oil_battery.png'},
    {'name': 'Air Battery', 'image': 'assets/images/air_battery.png'},
    {'name': 'Fuel Battery', 'image': 'assets/images/fuel_battery.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Batteries'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: batteries.length,
        itemBuilder: (context, index) {
          final item = batteries[index];
          return GestureDetector(
            onTap: () {
              // يمكنك وضع أي إجراء عند الضغط
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['name']} selected')),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      item['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
