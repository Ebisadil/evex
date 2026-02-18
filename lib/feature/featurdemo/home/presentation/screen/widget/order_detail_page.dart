import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/cart_page.dart';

class EventDetailPage extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String date;
  final double price;
  final String category;
  final double longitude;
  final double latitude;

  const EventDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.category,
    this.longitude = 76.2673,
    this.latitude = 9.9312,
  });

  // UI Colors
  static const Color bgColor = Color.fromARGB(255, 246, 246, 246);
  static const Color cardColor = Color.fromARGB(255, 165, 203, 192);
  static const Color accentPink = Color(0xFFF2D27A);
  static const Color textGrey = Color.fromARGB(255, 43, 47, 53);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUrgencyBanner(),
                      const SizedBox(height: 20),
                      _buildDateTimeRow(),
                      const SizedBox(height: 20),
                      _buildVenueSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildEventInfoSection(),
                      const SizedBox(height: 120), // Bottom padding for FAB
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Navigation Bar
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: _buildCircularIcon(Icons.arrow_back_ios_new),
                ),
                const Text(
                  "Event Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Row(
                  children: [
                    _buildCircularIcon(Icons.favorite_border),
                    const SizedBox(width: 10),
                    _buildCircularIcon(Icons.share),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Purchase Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomBar(context), // PASS CONTEXT HERE
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          height: 450,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF1E293B).withOpacity(0.4),
                bgColor
              ],
            ),
          ),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  category.isEmpty
                      ? "LIVE PERFORMANCE"
                      : category.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1),
              ),
              const SizedBox(height: 8),
              Text(
                "Featuring the best in ${category.isEmpty ? 'entertainment' : category}",
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildUrgencyBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.whatshot, color: Color(0xFFD4AF37)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 14),
                children: [
                  TextSpan(text: "Limited Availability: "),
                  TextSpan(
                    text: "Only 15 tickets left at this price!",
                    style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      children: [
        _buildInfoCard(
          icon: Icons.calendar_today,
          iconColor: const Color(0xFFD4AF37),
          label: "DATE",
          textstyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          value: date.isEmpty ? "Fri, Oct 24, 2024" : date,
        ),
        const SizedBox(width: 15),
        _buildInfoCard(
          icon: Icons.access_time,
          iconColor: const Color(0xFFD4AF37),
          label: "TIME",
          textstyle: const TextStyle(
            color: Color(0xFF8190A3),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          value: "8:00 PM • Doors 7:00",
        ),
      ],
    );
  }

  Widget _buildVenueSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                  backgroundColor: Color(0xFF3B3B2F),
                  child: Icon(Icons.location_on, color: Color(0xFFD4AF37))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("VENUE",
                        style: TextStyle(
                            color: Color(0xFF8190A3),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    Text(location,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              ),
              const Text("VIEW MAP",
                  style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.white10,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('event_location'),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(
                      title: location,
                    ),
                  ),
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About the Artist",
            style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text(
          "This event brings together the most talented artists for an unforgettable experience. Don't miss out on this atmospheric live visual journey.",
          style: TextStyle(
              color: Color.fromARGB(255, 48, 53, 60),
              fontSize: 15,
              height: 1.5),
        ),
        const SizedBox(height: 8),
        const Text("Read More",
            style: TextStyle(
                color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEventInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Event Info",
            style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _infoItem("Age Limit: 18+ (ID Required)"),
        _infoItem("Reserved Seating & General Admission Floor"),
        _infoItem("On-site Parking available"),
      ],
    );
  }

  Widget _infoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: accentPink, size: 20),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
        ],
      ),
    );
  }

  // ✅ UPDATED BOTTOM BAR (NAVIGATION ADDED)
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
      decoration: const BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("STARTING FROM",
                  style: TextStyle(
                      color: textGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
              Text("₹ $price",
                  style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF2D27A),
                  Color(0xFFE1BC4E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartReviewScreen(
                          image: image,
                          title: title,
                          date: date,
                          price: price,
                        ),
                      ));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Text(
                    "Select Tickets",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required Color iconColor,
      required String label,
      required String value,
      required TextStyle textstyle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF8190A3),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
