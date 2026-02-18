import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mainproject/core/models/location_model.dart';
import 'package:mainproject/core/widgets/fixed_image.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/map_screen.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/cart_page.dart';

class EventDetailPage extends StatefulWidget {
  final String image;
  final String title;
  final String location;
  final String date;
  final double price;
  final String category;
  final double latitude;
  final double longitude;

  const EventDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final eventLocation = LocationModel(
      id: "ocha2026",
      name: widget.title,
      address: widget.location,
      coordinates: LatLng(widget.latitude, widget.longitude),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),

      // ✅ CORRECT BOTTOM BUTTON

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              print('Image: ${widget.image}');
              print('Title: ${widget.title}');
              print('Date: ${widget.date}');
              print('Location: ${widget.location}');
              print('Price: ${widget.price}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartReviewScreen(
                    image: '',
                    title: widget.title,
                    date: widget.date,
                    price: widget.price,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF279475),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Book Ticket",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FixedBoxImage(
              imagePath: widget.image,
              width: double.infinity,
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "About Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This event brings world-class performances, unforgettable experiences, and premium entertainment.",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 250,
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: eventLocation.coordinates,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('event_location_marker'),
                            position: eventLocation.coordinates,
                            infoWindow: InfoWindow(
                              title: widget.title,
                              snippet: widget.location,
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text("View on Map"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF279475),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(locations: [eventLocation]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
