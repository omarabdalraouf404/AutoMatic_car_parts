import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:url_launcher/url_launcher.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String locationText = "Delivering to..."; // النص الافتراضي للموقع

  // دالة لفتح جوجل ماب وتحديد الموقع
  Future<void> openGoogleMaps() async {
    try {
      // الحصول على الموقع الجغرافي الحالي
      var locationData = await loc.Location().getLocation();

      // تحقق من وجود إحداثيات الموقع
      if (locationData.latitude == null || locationData.longitude == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location data is unavailable")));
        return;
      }

      // الحصول على تفاصيل الموقع باستخدام الإحداثيات
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(
            locationData.latitude!,
            locationData.longitude!,
          );

      geocoding.Placemark place = placemarks[0];

      // بناء الرابط مع إحداثيات الموقع لفتح Google Maps
      final String googleMapUrl =
          'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}';
      final Uri url = Uri.parse(googleMapUrl);

      // محاولة فتح الخريطة
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not open the map';
      }

      // تحديث النص لعرض الموقع الذي تم تحديده
      setState(() {
        locationText =
            "Delivering to ${place.subLocality ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}";
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to get location: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
