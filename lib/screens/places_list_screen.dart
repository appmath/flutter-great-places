import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(title: const Text('Your Places'),
          // backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, AddPlaceScreen.routeName);
              },
            ),
          ]),
      body: // Note that child might be tied to the main widget, it doesn't get updated
          FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, dataSnapshot) => dataSnapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (BuildContext ctx, GreatPlaces greatPlaces,
                        Widget? ch) =>
                    greatPlaces.items.length <= 0
                        ? ch!
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final Place place = greatPlaces.items[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(place.image),
                                ),
                                title: Text(place.title),
                                subtitle: Text(place.location.nonNullAddress),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      PlaceDetailScreen.routeName,
                                      arguments: place.id);
                                },
                              );
                            },
                            itemCount: greatPlaces.items.length,
                          ),
              ),
      ),
    );
  }
}
