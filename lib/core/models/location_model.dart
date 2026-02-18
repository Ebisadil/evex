import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String id;
  final String name;
  final String address;
  final LatLng coordinates;
  final String? imageUrl;

  LocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    this.imageUrl,
  });
}

// Mock locations data
final List<LocationModel> mockLocations = [
  LocationModel(
    id: '1',
    name: 'Madison Square Garden',
    address: 'New York, USA',
    coordinates: const LatLng(40.7505, -73.9934),
  ),
  LocationModel(
    id: '2',
    name: 'Central Park',
    address: 'New York, USA',
    coordinates: const LatLng(40.7829, -73.9654),
  ),
  LocationModel(
    id: '3',
    name: 'Brooklyn Bridge Park',
    address: 'Brooklyn, USA',
    coordinates: const LatLng(40.7061, -73.9969),
  ),
  LocationModel(
    id: '4',
    name: 'Times Square',
    address: 'New York, USA',
    coordinates: const LatLng(40.7580, -73.9855),
  ),
  LocationModel(
    id: '5',
    name: 'Rockefeller Center',
    address: 'New York, USA',
    coordinates: const LatLng(40.7528, -73.9772),
  ),
];
