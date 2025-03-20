import 'package:workshop_app/core/utils/assets.dart';

class SparePartsModel {
  final String image, text;
  final double price;

  SparePartsModel({
    required this.image,
    required this.text,
    required this.price,
  });
}

List<SparePartsModel> sparePartsList = [
  SparePartsModel(
    image: AppImages.spareParts1,
    text: "Drilled  Slotted",
    price: 20,
  ),
  SparePartsModel(
    image: AppImages.spareParts2,
    text: "Drilled  Dark",
    price: 30,
  ),
  SparePartsModel(image: AppImages.spareParts3, text: "Generic NGK", price: 10),
  SparePartsModel(
    image: AppImages.spareParts4,
    text: "MagnaFlow Exhaust",
    price: 50,
  ),
  SparePartsModel(
    image: AppImages.spareParts5,
    text: "MagnaFlow Exhaust",
    price: 30,
  ),
  SparePartsModel(
    image: AppImages.spareParts6,
    text: "MagnaFlow Exhaust",
    price: 20,
  ),
];
