import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassArrowWidget extends StatefulWidget {
  final double bearingToSite; // Bearing to the target site in degrees

  const CompassArrowWidget({Key? key, required this.bearingToSite})
      : super(key: key);

  @override
  _CompassArrowWidgetState createState() => _CompassArrowWidgetState();
}

class _CompassArrowWidgetState extends State<CompassArrowWidget> {
  double _direction = 0.0;
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();

    _compassSubscription = FlutterCompass.events?.listen((event) {
      final heading = event.heading;
      if (heading == null) return;

      // Calculate the direction to point the arrow
      double direction =
          (widget.bearingToSite - heading + 360) % 360.0; // Ensure positive value

      setState(() {
        _direction = direction;
      });
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 150.0, // Adjust position as needed
      left: 0,
      right: 0,
      child: Center(
        child: Transform.rotate(
          angle: _direction * (pi / 180),
          child: Icon(
            Icons.navigation, // Use any arrow icon you prefer
            color: Colors.red,
            size: 80.0,
          ),
        ),
      ),
    );
  }
}
