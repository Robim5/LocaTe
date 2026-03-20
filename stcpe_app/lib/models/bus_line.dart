import 'package:flutter/material.dart';

class BusLine {
  final String number;
  final Color color;
  final String origin;
  final String destination;
  final String municipality;
  final List<String> stopsForward;
  final List<String> stopsReverse;
  bool isFavorite;

  BusLine({
    required this.number,
    required this.color,
    required this.origin,
    required this.destination,
    required this.municipality,
    required this.stopsForward,
    required this.stopsReverse,
    this.isFavorite = false,
  });

  String get routeLabel => '$origin \u2194 $destination';
  String get forwardLabel => '$origin \u2192 $destination';
  String get reverseLabel => '$destination \u2192 $origin';
}
