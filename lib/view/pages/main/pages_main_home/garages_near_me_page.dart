import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class GaragesNearMe {
  final String name;
  final String address;
  final double distance; // بالكيلومتر
  final double rating;
  final LatLng location;
  final String? placeId;
  final String? vicinity;
  final String? photoReference;

  GaragesNearMe({
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.location,
    this.placeId,
    this.vicinity,
    this.photoReference,
  });

  factory GaragesNearMe.fromPlaceResult(Map<String, dynamic> place, LatLng userLocation) {
    final location = LatLng(
      place['geometry']['location']['lat'],
      place['geometry']['location']['lng'],
    );
    
    // حساب المسافة
    final distance = _calculateDistance(
      userLocation.latitude, 
      userLocation.longitude,
      location.latitude,
      location.longitude,
    );
    
    String photoRef = '';
    if (place['photos'] != null && (place['photos'] as List).isNotEmpty) {
      photoRef = place['photos'][0]['photo_reference'];
    }
    
    return GaragesNearMe(
      name: place['name'],
      address: place['vicinity'] ?? '',
      distance: distance,
      rating: place['rating']?.toDouble() ?? 0.0,
      location: location,
      placeId: place['place_id'],
      vicinity: place['vicinity'],
      photoReference: photoRef,
    );
  }
  
  // حساب المسافة بين نقطتين باستخدام صيغة هافرسين
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // بالكيلومتر
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = pow(sin(dLat / 2), 2) + 
               cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * 
               pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }
  
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}

class GaragesNearMePage extends StatefulWidget {
  const GaragesNearMePage({Key? key}) : super(key: key);

  @override
  State<GaragesNearMePage> createState() => _GaragesNearMePageState();
}

class _GaragesNearMePageState extends State<GaragesNearMePage> {
  bool _isLoading = true;
  loc.LocationData? _currentLocation;
  List<GaragesNearMe> _nearbyGarages = [];
  GoogleMapController? _mapController;
  
  
  // موقع افتراضي (يمكن تغييره لاحقاً)
  final LatLng _defaultLocation = const LatLng(30.0444, 31.2357); // القاهرة
  Set<Marker> _markers = {};
  String _currentAddress = '';
  
  // مفتاح Google Places API - يجب استبداله بمفتاح صالح
  final String _apiKey = 'AIzaSyBx10ci4eMaIGUs9BEe4wPzs2dZuclIeD0'; // استبدل هذا بمفتاح API الخاص بك

  // عرض رسالة خطأ في حال حدوث مشكلة في الموقع
  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionStatus;

    // التحقق من تفعيل خدمة الموقع
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showLocationError('Location services are disabled. Please enable them.');
        return;
      }
    }

    // التحقق من أذونات الموقع
    permissionStatus = await location.hasPermission();
    if (permissionStatus == loc.PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != loc.PermissionStatus.granted) {
        _showLocationError('Location permissions are denied');
        return;
      }
    }

    try {
      // الحصول على الموقع الحالي
      _currentLocation = await location.getLocation();
      
      // الحصول على العنوان من الإحداثيات
      await _getAddressFromLatLng();
      
      setState(() {
        _isLoading = false;
      });
      
      // البحث عن الورش القريبة
      await _searchNearbyGarages();
      
      _addMarkers();
    } catch (e) {
      _showLocationError('Failed to get current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (_currentLocation == null || _currentLocation!.latitude == null || _currentLocation!.longitude == null) {
      return;
    }
    
    try {
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );
      
      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> _searchNearbyGarages() async {
    if (_currentLocation == null || _currentLocation!.latitude == null || _currentLocation!.longitude == null) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // استعلام Google Places API للبحث عن الورش القريبة
      final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${_currentLocation!.latitude},${_currentLocation!.longitude}'
          '&radius=5000'  // البحث في نطاق 5 كيلومتر
          '&types=car_repair'  // نوع المكان (ورش إصلاح السيارات)
          '&language=ar'  // اللغة العربية
          '&key=$_apiKey';
          
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final List<dynamic> results = data['results'];
          final currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
          
          // تحويل النتائج إلى كائنات GaragesNearMe
          _nearbyGarages = results
              .map((place) => GaragesNearMe.fromPlaceResult(place, currentLatLng))
              .toList();
          
          // ترتيب الورش حسب المسافة (الأقرب أولاً)
          _nearbyGarages.sort((a, b) => a.distance.compareTo(b.distance));
          
          setState(() {
            _isLoading = false;
          });
          
          _addMarkers();
        } else {
          _showLocationError('Failed to fetch garages: ${data['status']}');
        }
      } else {
        _showLocationError('Failed to fetch garages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showLocationError('Error searching for garages: $e');
    }
  }

  void _addMarkers() {
    if (_currentLocation == null) return;
    
    Set<Marker> markers = {};
    
    // إضافة علامة لموقع المستخدم
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        infoWindow: const InfoWindow(title: 'موقعك الحالي'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // إضافة علامات للورش
    for (var i = 0; i < _nearbyGarages.length; i++) {
      final garage = _nearbyGarages[i];
      markers.add(
        Marker(
          markerId: MarkerId('garage_$i'),
          position: garage.location,
          infoWindow: InfoWindow(
            title: garage.name,
            snippet: '${garage.distance.toStringAsFixed(1)} كم',
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  // إتاحة فتح Google Maps للتوجيه إلى الورشة
  Future<void> _launchMapsUrl(double latitude, double longitude, String label) async {
    final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&destination_place_id=$label';
    final Uri url = Uri.parse(googleMapsUrl);
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not open the map';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open maps: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الورش القريبة منك'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // عرض العنوان الحالي
                if (_currentAddress.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    color: Colors.blue.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'موقعك الحالي: $_currentAddress',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // خريطة تظهر الورش
                SizedBox(
                  height: 250.h,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation != null
                          ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
                          : _defaultLocation,
                      zoom: 14,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),
                
                // عنوان القسم وزر التحديث
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الورش القريبة منك',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${_nearbyGarages.length} ورشة',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // زر تحديث البحث
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.blue),
                            onPressed: _searchNearbyGarages,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // قائمة الورش
                Expanded(
                  child: _nearbyGarages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.build, size: 50.sp, color: Colors.grey),
                              SizedBox(height: 16.h),
                              Text(
                                'لم يتم العثور على ورش قريبة',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ElevatedButton(
                                onPressed: _searchNearbyGarages,
                                child: Text('إعادة البحث'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _nearbyGarages.length,
                          itemBuilder: (context, index) {
                            final garage = _nearbyGarages[index];
                            return GarageListItem(
                              garage: garage,
                              onTap: () {
                                // عند الضغط على ورشة معينة
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(garage.location, 16),
                                );
                              },
                              onDirectionsTap: () {
                                _launchMapsUrl(
                                  garage.location.latitude,
                                  garage.location.longitude,
                                  garage.placeId ?? '',
                                );
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

class GarageListItem extends StatelessWidget {
  final GaragesNearMe garage;
  final VoidCallback onTap;
  final VoidCallback onDirectionsTap;

  const GarageListItem({
    Key? key,
    required this.garage,
    required this.onTap,
    required this.onDirectionsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // أيقونة الورشة
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.build,
                        size: 30.sp,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    
                    // تفاصيل الورشة
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            garage.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            garage.address,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              // تقييم الورشة
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 18.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    garage.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16.w),
                              // المسافة
                              Row(
                                children: [
                                  Icon(Icons.directions_car, color: Colors.grey, size: 18.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${garage.distance.toStringAsFixed(1)} كم',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // أزرار الإجراءات (الاتصال، التوجيه)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onDirectionsTap,
                      icon: Icon(Icons.directions, size: 18.sp),
                      label: Text('توجيه'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
