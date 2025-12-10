// widgets/custom_google_map.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initCameraPosition;
  late GoogleMapController googleMapController;
  String? mapStyle;
  Set<Marker> markers = {};
  @override
  void initState() {
    initCameraPosition = CameraPosition(
      target: LatLng(30.812496158853147, 31.03437658728564),
      zoom: 5,
    );
    initMapStyle();
    initMarkers();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          style: mapStyle,
          mapType: MapType.normal,
          markers: markers,
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(southwest: LatLng(20, 10), northeast: LatLng(25, 15)),
          // ),
          initialCameraPosition: initCameraPosition,
          onMapCreated: (controller) async {
            googleMapController = controller;
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: () {
              googleMapController.animateCamera(
                CameraUpdate.newLatLng(LatLng(50, 31.03437658728564)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Future<void> initMapStyle() async {
    //* load json file
    mapStyle = await rootBundle.loadString(
      'assets/map_styles/aubergine_style.json',
    );
    setState(() {});
    //* Update map style
    // googleMapController.setMapStyle(loadStyle);
  }

  void initMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(50, 30),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          googleMapController.animateCamera(
            CameraUpdate.newLatLng(LatLng(50, 30)),
          );
        },
      ),
    );
  }
}
//* 1- Setup Google Map
//* 2- Simple Map (initialCameraPosition, zoom, cameraTargetBounds, controller)
//* 3- Map Style & type (mapType attribute) , customaize style and add json file (style operate only with normal map type)
//* 4- Markers (set of marker) includes markerId, position, onTap