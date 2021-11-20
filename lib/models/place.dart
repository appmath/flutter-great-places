import 'dart:io';

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place(
      {required this.id,
      required this.title,
      required this.location,
      required this.image});
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  String get nonNullAddress {
    var nonNullAddress = address != null ? address! : '${address}';
    print('Returning non null address: $nonNullAddress');
    return nonNullAddress;
  }
}
