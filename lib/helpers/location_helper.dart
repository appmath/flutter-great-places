import 'dart:convert';

import 'package:http/http.dart' as http;

const google_api_key = 'AIzaSyAMmqlqj9iKJAw_FaIzINGJZyvQQ4f5qf4';

class LocationHelper {
  static String generateLocationPreviewImage(
      {required double? latitude, required double? longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap'
        '&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$google_api_key';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$google_api_key';
    final response = await http.get(Uri.parse(url));
    var responseBody = json.decode(response.body);
    print('Response: ${responseBody}');
    var address = responseBody['results'][0]['formatted_address'];
    print('address: $address');
    return address;
  }
}

// TODO Add this package and some examples
// Description: A Flutter plugin that provides a Google Maps widget.
// URL: https://pub.dev/packages/google_maps_flutter
// Install:flutter pub add google_maps_flutter
// Console for example: https://console.cloud.google.com/google/maps-apis/api-list?project=flutter-greatplaces-332522
// API: https://developers.google.com/maps/documentation/geocoding/start#reverse
//
// App: Name (full location)

// Examples:
// https: //github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter/example/lib

// Full example
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// const google_api_key = 'AIzaSyAMmqlqj9iKJAw_FaIzINGJZyvQQ4f5qf4';
//
// class LocationHelper {
//   static String generateLocationPreviewImage(
//       {required double? latitude, required double? longitude}) {
//     return 'https://maps.googleapis.com/maps/api/staticmap'
//         '?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap'
//         '&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$google_api_key';
//   }
//
//   static Future<String> getPlaceAddress(double lat, double lng) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$google_api_key';
//     final response = await http.get(Uri.parse(url));
//     var responseBody = json.decode(response.body);
//     print('Response: ${responseBody}');
//     var address = responseBody['results'][0]['formatted_address'];
//     print('address: $address');
//     return address;
//   }
// }

// MIGHT NEED TO BE IMPORTED MANUALLY:
// import 'package:http/http.dart' as http;
//
// // Description: consume HTTP resources
// // URL: https://pub.dev/packages/http
// // Install: flutter pub add http
// // App: Angela's bitcoin_picker (src/mobile/flutter/learning/udemy/complete-flutter-app-development-bootcamp-with-dart/section-14/bitcoin_picker)
//
// // Example:
// http.Response response = await http.get(Uri.parse(requestURL));
//
// // Full example
// class CoinData {
//   Future getCoinData(String selectedCurrency) async {
//     Map<String, String> map = {};
//     for (var crypto in cryptoList) {
//       String requestURL =
//           '$coinAPIURL/$crypto/$selectedCurrency?apiKey=$apiKey';
//       // String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';
//       http.Response response = await http.get(Uri.parse(requestURL));
//
//       if (response.statusCode == 200) {
//         var decodedData = jsonDecode(response.body);
//         var lastPrice = decodedData['rate'];
//
//         map[crypto] = lastPrice.toStringAsFixed(0);
//       } else {
//         print(response.statusCode);
//         throw 'Problem with the get request';
//       }
//     }
//     print('Map: $map');
//     return map;
//   }
// }
