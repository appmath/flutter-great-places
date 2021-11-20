import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/widgets/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput({required this.onSelectPlace});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    var staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    late LocationData locData;
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      //TODO: do your logic to manage when user denies the permission
      if (permissionGranted != PermissionStatus.granted) {
        print('User denied permission');
        return;
      }
    }

    // LocationData? locData;
    try {
      locData = await Location().getLocation();
    } catch (e) {
      print(e);
    }
    if (locData.longitude != null && locData.longitude != null) {
      var staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: locData.latitude, longitude: locData.longitude);
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) {
      print('selectedLocation.latitude: null');

      return;
    }
    print('selectedLocation.latitude: ${selectedLocation.latitude}');
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  //primary: Theme.of(context).colorScheme.primary
                  primary: Theme.of(context).colorScheme.primary),
              label: Text('Current Location'),
              icon: Icon(Icons.location_on),
              onPressed: _getCurrentUserLocation,
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  //primary: Theme.of(context).colorScheme.primary
                  primary: Theme.of(context).colorScheme.primary),
              label: Text('Select on Map'),
              icon: Icon(Icons.map),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
