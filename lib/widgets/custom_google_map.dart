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
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
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
      zoom: 3,
    );
    initMapStyle();
    addMarkers();
    addPolyLines();
    addPloygons();
    addCircles();
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
          polygons: polygons,
          polylines: polylines,
          circles: circles,
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
            setState(() {});
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

  void addPolyLines() {
    polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        patterns: [PatternItem.dot],
        color: Colors.red,
        width: 5,
        startCap: Cap.roundCap,
        points: [
          LatLng(30.78873594195323, 31.001931686920013),
          LatLng(30.78389436117895, 30.99868154821272),
          LatLng(30.78332721540586, 31.005805751862734),
        ],
      ),
    );
    setState(() {});
  }

  void addPloygons() {
    polygons.add(
      Polygon(
        polygonId: PolygonId('1'),
        holes: [
          //* to make hole or hide region of polygon
          [
            LatLng(29.564112766816205, 30.941956060658942),
            LatLng(29.329369577696976, 31.017184384017128),
            LatLng(29.121471220340695, 30.82284454867514),
            LatLng(29.10504023298866, 30.703733036691336),
            LatLng(29.209058804354726, 30.563724768219153),
            LatLng(29.402216222314603, 30.484317093563288),
          ],
        ],
        points: [
          LatLng(31.68310023487944, 33.12899325429337),
          LatLng(31.778751239088866, 25.144272991077685),
          LatLng(24.241411229192067, 24.806890444744628),
          LatLng(22.08970811902912, 36.73872990902558),
        ],
        fillColor: Colors.green.withValues(alpha: .5),
      ),
    );
    setState(() {});
  }

  void addCircles() {
    circles.add(
      Circle(
        circleId: CircleId('1'),
        radius: 500,
        fillColor: Colors.red,
        center: LatLng(28.923563382083824, 30.8478336809978),
      ),
    );
  }
}
//* 1- Setup Google Map
//* 2- Simple Map (initialCameraPosition, zoom, cameraTargetBounds, controller)
//* 3- Map Style & type (mapType attribute) , customaize style and add json file (style operate only with normal map type)
//* 4- Markers (set of marker) includes markerId, position, onTap
//* 5- Polylines (set of polyline) includes polylineId, color, width, points
//* 6- Polygons (set of polygon) includes polygonId, points, fillColor => design 2D shape (Rectangle, square, triangle)
//* 7- Circles (set of circle) includes circleId, fillColor, center, radius

//! zoom value => 0:3 if world
//! zoom value => 4:6 if country
//! zoom value => 10:12 if city
//! zoom value => 13:16 if street 
//! zoom value => 17:20 if building 
