import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/house_details.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_house.g.dart';

@JsonSerializable()
class SimpleHouse {
  String id;
  String title;
  double price;
  int roomCount;
  double area;
  int? floor;
  String city;
  String voivodeship;
  String zipCode;
  String? district;
  String? streetName;
  String? streetNumber;
  String? flatNumber;
  @OfferTypeConverter()
  OfferType offerType;
  @BuildingTypeConverter()
  BuildingType buildingType;
  bool isLiked;
  String? photoUrl;

  SimpleHouse(
      this.id,
      this.title,
      this.price,
      this.roomCount,
      this.area,
      this.floor,
      this.city,
      this.voivodeship,
      this.zipCode,
      this.district,
      this.streetName,
      this.streetNumber,
      this.flatNumber,
      this.offerType,
      this.buildingType,
      this.isLiked,
      this.photoUrl);

  Map<String, dynamic> toJson() => _$SimpleHouseToJson(this);
  factory SimpleHouse.fromJson(Map<String, dynamic> json) =>
      _$SimpleHouseFromJson(json);

  House toHouse() {
    return House(
      id: id,
      Location(
        city: city,
        voivodeship: voivodeship,
        district: district,
        streetName: streetName,
        zipCode: zipCode,
        streetNumber: streetNumber,
        flatNumber: flatNumber,
      ),
      HouseDetails(
        title: title,
        price: price,
        roomCount: roomCount,
        area: area,
        floor: floor,
        buildingType: buildingType,
      ),
      Photo(
        filename: "",
        url: photoUrl != null
            ? photoUrl!
            : "https://picsum.photos/600/900?=${DateTime.now().millisecondsSinceEpoch}",
        order: 0,
      ),
      offerType: offerType,
      isLiked: isLiked,
    );
  }
}
