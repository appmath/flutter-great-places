import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
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
                Consumer<GreatPlaces>(
              child: const Center(
                child: Text('Got no places yet, start adding some!'),
              ),
              builder:
                  (BuildContext ctx, GreatPlaces greatPlaces, Widget? ch) =>
                      greatPlaces.items.length <= 0
                          ? ch!
                          :
                          // DON'T FORGET TO SPECIFY THE itemCount!!!!
                          ListView.builder(
                              itemBuilder: (context, index) {
                                final Place place = greatPlaces.items[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(place.image),
                                  ),
                                  title: Text(place.title),
                                  onTap: () {},
                                );
                              },
                              itemCount: greatPlaces.items.length,
                            ),
            ));
  }
}
