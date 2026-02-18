import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mainproject/core/models/location_model.dart';

class MapScreen extends StatefulWidget {
  final List<LocationModel>? locations;

  const MapScreen({
    super.key,
    this.locations,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  List<LocationModel> get _locations => widget.locations ?? mockLocations;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.clear();

    for (final location in _locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.coordinates,
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitAllMarkers();
  }

  void _fitAllMarkers() {
    if (_locations.isEmpty || _mapController == null) return;

    if (_locations.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          _locations.first.coordinates,
          15,
        ),
      );
      return;
    }

    double south = _locations.first.coordinates.latitude;
    double north = _locations.first.coordinates.latitude;
    double west = _locations.first.coordinates.longitude;
    double east = _locations.first.coordinates.longitude;

    for (final loc in _locations) {
      south =
          south < loc.coordinates.latitude ? south : loc.coordinates.latitude;
      north =
          north > loc.coordinates.latitude ? north : loc.coordinates.latitude;
      west =
          west < loc.coordinates.longitude ? west : loc.coordinates.longitude;
      east =
          east > loc.coordinates.longitude ? east : loc.coordinates.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_locations.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          backgroundColor: const Color.fromARGB(255, 39, 148, 117),
        ),
        body: const Center(
          child: Text("No locations available"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Locations"),
        backgroundColor: const Color.fromARGB(255, 39, 148, 117),
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _locations.first.coordinates,
              zoom: 12,
            ),
            markers: _markers,
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
          ),

          // 🔽 Bottom Location List
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _locations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final location = _locations[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 39, 148, 117),
                    ),
                    title: Text(
                      location.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      location.address,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          location.coordinates,
                          15,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
