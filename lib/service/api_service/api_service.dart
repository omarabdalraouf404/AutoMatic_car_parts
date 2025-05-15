import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workshop_app/model/product_model.dart';

class ApiService {
  static Future<List<ProductModel>> fetchProducts() async {
    const String url =
        "http://192.168.248.153/car_api/get_products.php"; // استبدل برابط API الخاص بك
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
