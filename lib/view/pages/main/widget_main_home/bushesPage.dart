import 'package:flutter/material.dart';

class BushesPage extends StatelessWidget {
  final List<Map<String, String>> bushes = [
    {'name': 'Front Bush', 'image': 'assets/images/front_bush.png'},
    {'name': 'Rear Bush', 'image': 'assets/images/rear_bush.png'},
    {'name': 'Side Bush', 'image': 'assets/images/side_bush.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: const Text('Bushes'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: bushes.length,
        itemBuilder: (context, index) {
          final item = bushes[index];
          return GestureDetector(
            onTap: () {
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                      style: const TextStyle(
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


// انسخ هذا الكود وكرّره مع تغيير الاسم والمحتوى للأنواع الأخرى:
// PumpsPage, BatteriesPage, SensorsPage, BushesPage, BeltsPage, BrakesPage, ExhaustPage, SuspensionPage
