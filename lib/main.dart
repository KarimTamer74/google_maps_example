// main.dart
import 'package:apply_google_maps/widgets/custom_google_map.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TestGoogleMap());
}

class TestGoogleMap extends StatelessWidget {
  const TestGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomGoogleMap(),
    );
  }
}
