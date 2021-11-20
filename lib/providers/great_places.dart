import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:great_places/helpers/constants.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);

    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        image: pickedImage,
        location: updatedLocation);

    _items.add(newPlace);
    notifyListeners();
    if (newPlace.location != null) {
      DBHelper.insert(kPlacesTable, {
        kId: newPlace.id,
        kTitle: newPlace.title,
        kImage: newPlace.image.path,
        kLocationLatitude: newPlace.location.latitude,
        kLocationLongitude: newPlace.location.longitude,
        kAddress: newPlace.location.nonNullAddress,
      });
    }
  }

  Future<void> fetchAndSetPlaces() async {
    var dataList = await DBHelper.getData(kPlacesTable);
    _items = dataList
        .map(
          (item) => Place(
            id: item[kId],
            title: item[kTitle],
            location: PlaceLocation(
              latitude: item[kLocationLatitude],
              longitude: item[kLocationLongitude],
              address: item[kAddress],
            ),
            image: File(item[kImage]),
          ),
        )
        .toList();
    notifyListeners();
  }
}
