import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _kMapCenter = LatLng(31.5204, 74.3587);
  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  Set<Marker> _markers = {};

void _addMarker(LatLng position, String title, String snippet, bool isWater) {
  final Marker marker = Marker(
    markerId: MarkerId(position.toString()),
    position: position,
    alpha: isWater? 1:0.5 ,
    infoWindow: InfoWindow(
      title: title,
      snippet: '$snippet Clean Water: ${isWater ? 'Yes' : 'No'}',
    ),
  );

  setState(() {
    _markers.add(marker);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Map",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        trafficEnabled: false,
        zoomControlsEnabled: true,
        markers: _markers,
        onMapCreated: (controller) async {
          String value = await DefaultAssetBundle.of(context)
              .loadString('assets/map_style.json');
          controller.setMapStyle(value);
        },
        onTap: (LatLng position) {
          _showLocationEntryDialog(position, context);
        },
      ),
    );
  }

  Future<void> _showLocationEntryDialog(LatLng position, BuildContext ctx) async {
    TextEditingController locationController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    bool hasCleanWater = false;

    await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add Location'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(labelText: 'Details'),
                  ),
                  Row(
                    children: [
                      const Text('Clean Water:'),
                      Checkbox(
                        value: hasCleanWater,
                        onChanged: (bool? value) {
                          setState(() {
                            hasCleanWater = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String location = locationController.text.trim();
                    String details = detailsController.text.trim();

                    if (location.isNotEmpty) {
                      _addMarker(position, location, details, hasCleanWater);
                      // You can save the details, hasCleanWater, etc., to Firebase or any other backend here.
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
