// widgets/custom_google_map.dart
import 'dart:developer';

import 'package:apply_google_maps/models/place_model.dart';
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
  List<PlaceModel> places = [
    PlaceModel(
      id: 1,
      name: 'مستشفى دار القمة',
      latLng: LatLng(30.78873594195323, 31.001931686920013),
    ),
    PlaceModel(
      id: 2,
      name: 'مطعم زينهم',
      latLng: LatLng(30.78332721540586, 31.005805751862734),
    ),
    PlaceModel(
      id: 3,
      name: 'السيد البدوي',
      latLng: LatLng(30.78389436117895, 30.99868154821272),
    ),
  ];
  @override
  void initState() {
    initCameraPosition = CameraPosition(
      target: LatLng(30.786618980711904, 31.000956025027943),
      zoom: 15,
    );
    initMapStyle();
    addMarkers();
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
          zoomControlsEnabled: false,
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
                CameraUpdate.newLatLng(LatLng(30, 31.03437658728564)),
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

  void addMarkers() async {
    BitmapDescriptor markerIcon = await initMarkerIcon();
    markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(50, 30),
        // icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          googleMapController.animateCamera(
            CameraUpdate.newLatLng(LatLng(50, 30)),
          );
        },
      ),
    );
    for (var place in places) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id.toString()),
          infoWindow: InfoWindow(title: place.name),
          icon: markerIcon,
          position: place.latLng,
          onTap: () {
            googleMapController.animateCamera(
              CameraUpdate.newLatLng(place.latLng),
            );
          },
        ),
      );
    }

    log(markers.length.toString(), name: 'markers');
    setState(() {});
  }

  Future<BitmapDescriptor> initMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/icons/marker_icon.png',
    );
  }
}
//* 1- Setup Google Map
//* 2- Simple Map (initialCameraPosition, zoom, cameraTargetBounds, controller)
//* 3- Map Style & type (mapType attribute) , customaize style and add json file (style operate only with normal map type)
//* 4- Markers (set of marker) includes markerId, position, onTap