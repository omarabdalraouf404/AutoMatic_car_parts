import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<Uint8List?> removeBackground(String imageUrl) async {
    final response = await http.post(
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
      headers: {
        'X-Api-Key': '5rEhLeZTxgXQV86enq5NAkAc', // استبدلها بمفتاح API الخاص بك
      },
      body: {'image_url': imageUrl, 'size': 'auto'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // ✅ إرجاع الصورة بدون خلفية
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }
}
