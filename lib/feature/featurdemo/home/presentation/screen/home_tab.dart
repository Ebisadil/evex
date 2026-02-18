import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'widget/banner_view.dart';
import 'widget/popular_events.dart';
import 'widget/reccomended.dart';
import 'widget/search_bar.dart';
import 'widget/suggestion_item.dart';
import 'widget/upcoming.dart';
import 'widget/order_detail_page.dart'; // assuming this is EventDetailPage

class NewHomeTab extends StatefulWidget {
  NewHomeTab({super.key});

  final List<String> bannerImages = [
    "assets/banner1.jpg",
    "assets/banner2.jpg",
    "assets/banner3.jpg",
  ];

  @override
  State<NewHomeTab> createState() => _NewHomeTabState();
}

class _NewHomeTabState extends State<NewHomeTab> {
  final PageController _upcomingPageController = PageController();

  // ── Location state ───────────────────────────────────────────────────────
  String _currentLocation = "Fetching location...";
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoadingLocation = true;
        _currentLocation = "Fetching location...";
      });
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentLocation = "Location services disabled";
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentLocation = "Location permission denied";
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = "Permission permanently denied";
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city =
            place.locality ?? place.subAdministrativeArea ?? "Unknown";
        String area = place.subLocality ?? "";

        setState(() {
          _currentLocation = area.isNotEmpty ? "$area, $city" : city;
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _currentLocation = "Location unavailable";
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = "Couldn't detect location";
        _isLoadingLocation = false;
      });
      debugPrint("Location error: $e");
    }
  }

  // ── Open location picker bottom sheet ────────────────────────────────────
  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationPickerSheet(
        currentLocation: _currentLocation,
        onUseGPS: () {
          Navigator.pop(context);
          _loadCurrentLocation(showLoading: true);
        },
        onLocationSelected: (String selected) {
          Navigator.pop(context);
          setState(() {
            _currentLocation = selected;
            _isLoadingLocation = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _upcomingPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              elevation: 1,
              expandedHeight: kToolbarHeight + 140,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // ✅ gives proper width
                            child: GestureDetector(
                              onTap: _openLocationPicker,
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.pin_drop,
                                    size: 32,
                                    color: Color(0xFF27A379),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    // ✅ allows text to shrink
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Current Location",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        _isLoadingLocation
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2.5),
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    // ✅ VERY IMPORTANT
                                                    child: Text(
                                                      _currentLocation,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    size: 20,
                                                    color: Colors.black45,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const HomeTabSearchBar(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BannerView(bannerImages: widget.bannerImages),
                    const SizedBox(height: 24),

                    PopularEvents(),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF27A379),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Upcoming Events PageView + indicator
                    SizedBox(
                      height: 250,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView(
                              controller: _upcomingPageController,
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming1.jpg",
                                        title:
                                            "Ocha Music Festival- Volume III, 2026",
                                        location: "Ernakulam",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming1.jpg",
                                                        title:
                                                            "Ocha Music Festival- Volume III, 2026",
                                                        location: "Ernakulam",
                                                        date:
                                                            'FEB 15, 2026, 6:00 PM',
                                                        price: 1250.00,
                                                        category: 'Music',
                                                        latitude: 9.9312,
                                                        longitude: 76.2673,
                                                      )));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming2.jpg",
                                        title: "Mentalist Mega Festival 2026",
                                        location: "Kochi",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming2.jpg",
                                                        title:
                                                            "Mentalist Mega Festival 2026",
                                                        location: "Kochi",
                                                        date:
                                                            'Jan 20, 2026, 5:00 PM',
                                                        price: 1500.00,
                                                        category:
                                                            'Entertainment',
                                                        latitude: 9.9312,
                                                        longitude: 76.2673,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming3.jpg",
                                        title:
                                            "Tom Morello India Tour- Bengaluru",
                                        location: "Bengaluru",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming3.jpg",
                                                        title:
                                                            "Tom Morello India Tour- Bengaluru",
                                                        location: "Bengaluru",
                                                        date:
                                                            'mar 10, 2026, 7:00 PM',
                                                        price: 1250.00,
                                                        category: 'tour',
                                                        latitude: 13.305660,
                                                        longitude: 77.81780,
                                                      )));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming4.jpg",
                                        title:
                                            "SPACETECH FESTIVAL WINTER EDITION",
                                        location: "Manali",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming4.jpg",
                                                        title:
                                                            "SPACETECH FESTIVAL WINTER EDITION",
                                                        location: "Manali",
                                                        date:
                                                            'feb 15, 2026, 6:00 PM',
                                                        price: 1500.00,
                                                        category:
                                                            'Entertainment',
                                                        latitude: 32.24339,
                                                        longitude: 77.18832,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming5.jpg",
                                        title:
                                            "John Mayer Solo Live In Mumbai, 2026",
                                        location: "Mumbai",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming5.jpg",
                                                        title:
                                                            "John Mayer Solo Live In Mumbai, 2026",
                                                        location: "Mumbai",
                                                        date:
                                                            'apr 5, 2026, 8:00 PM',
                                                        price: 1250.00,
                                                        category: 'Music',
                                                        latitude: 19.21478,
                                                        longitude: 72.98208,
                                                      )));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming6.jpg",
                                        title:
                                            "Chess Tournament With Artificial Intelligence (AI)",
                                        location: "Delhi",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming6.jpg",
                                                        title:
                                                            "Chess Tournament With Artificial Intelligence (AI)",
                                                        location: "Delhi",
                                                        date:
                                                            'MAY 12, 2026, 10:00 AM',
                                                        price: 1500.00,
                                                        category:
                                                            'Entertainment',
                                                        latitude: 28.68746,
                                                        longitude: 77.24292,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming7.jpg",
                                        title:
                                            "Kisi Ko Batana Mat Ft. Anubhav Singh Bassi",
                                        location: "New York",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming7.jpg",
                                                        title:
                                                            "Kisi Ko Batana Mat Ft. Anubhav Singh Bassi",
                                                        location: "New York",
                                                        date:
                                                            'JUN 18, 2026, 7:00 PM',
                                                        price: 10000.00,
                                                        category: 'Music',
                                                        latitude: 40.72108,
                                                        longitude: 73.983663,
                                                      )));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming8.jpg",
                                        title:
                                            "CALVIN HARRIS Live In Bengaluru",
                                        location: "Bengaluru",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming8.jpg",
                                                        title:
                                                            "CALVIN HARRIS Live In Bengaluru",
                                                        location: "Bengaluru",
                                                        date:
                                                            'JUL 22, 2026, 8:00 PM',
                                                        price: 1500.00,
                                                        category: 'Music',
                                                        latitude: 12.98076,
                                                        longitude: 77.55678,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming9.jpg",
                                        title: "Post Malone Live In Guwahati",
                                        location: "Guwahati",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming9.jpg",
                                                        title:
                                                            "Post Malone Live In Guwahati",
                                                        location: "Guwahati",
                                                        date:
                                                            'AUG 30, 2026, 7:00 PM',
                                                        price: 4000.00,
                                                        category: 'Music',
                                                        latitude: 26.11716,
                                                        longitude: 91.71181,
                                                      )));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: upcomingEventCard(
                                        image: "assets/upcoming10.jpg",
                                        title:
                                            "Calum Scott - The Avenoir Tour 2026",
                                        location: "Gurgaon",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EventDetailPage(
                                                        image:
                                                            "assets/upcoming10.jpg",
                                                        title:
                                                            "Calum Scott - The Avenoir Tour 2026",
                                                        location: "Gurgaon",
                                                        date:
                                                            'DEC 5, 2026, 8:00 PM',
                                                        price: 2500.00,
                                                        category: 'TOUR',
                                                        latitude: 26.11716,
                                                        longitude: 91.71181,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SmoothPageIndicator(
                            controller: _upcomingPageController,
                            count: 5,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: const Color(0xFFE1BC4E),
                              dotColor: const Color(0xFFF2D27A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recommended For You",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 320,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          ReccomendedEvent(
                            image: "assets/pro1.jpg",
                            category: "Event",
                            hostName: "jhon",
                            title: "Corporate Event Mana...",
                            dateRange: "THU 25 DEC, 9:00 -FRI 27 DEC, 10:00",
                            price: 5000,
                            attendees: [],
                            hostImage: "assets/host1.jpg",
                          ),
                          ReccomendedEvent(
                            image: "assets/pro2.jpg",
                            category: "Music",
                            hostName: "Hanansha",
                            title: "Music & Entertainment In Kerala",
                            dateRange: "MON 01 JAN, 7:00 -WED 15 JAN, 12:00",
                            price: 4500,
                            attendees: [],
                            hostImage: "assets/host2.jpg",
                          ),
                          ReccomendedEvent(
                            image: "assets/pro3.jpg",
                            category: "Private",
                            hostName: "juliy",
                            title: "Private Parties Kerala",
                            dateRange: "FRI 20 FEB, 5:00 -SUN 26 FEB, 10:00",
                            price: 2000,
                            attendees: [],
                            hostImage: "assets/host3.jpg",
                          ),
                          ReccomendedEvent(
                            image: "assets/pro4.jpg",
                            category: "Destination",
                            hostName: "Teena",
                            title: "Destination Wedding in Kerala",
                            dateRange: "THU 25 MAR, 1:00 -FRI 30 JUN, 5:00",
                            price: 5000,
                            attendees: [],
                            hostImage: "assets/host4.jpg",
                          ),
                          ReccomendedEvent(
                            image: "assets/pro5.jpg",
                            category: "Wedding",
                            hostName: "Rohith",
                            title: "Wedding Planners in Kerala",
                            dateRange: "THU 25 AUG, 9:00 -FRI 27 AUG, 10:00",
                            price: 5000,
                            attendees: [],
                            hostImage: "assets/host5.jpg",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Suggestions for you",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("See All"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SuggestionItem(
                            image: "assets/sug1.jpg",
                            title:
                                "New Year Bash At The Drunken Botanist – 2026",
                            location: "Gurugram",
                            price: 2499,
                          ),
                          SuggestionItem(
                            image: "assets/sug2.jpg",
                            title:
                                "Songs of the Stone | Musical Experience at Qutub Minar – 2026",
                            location: "Qutub Minar, Delhi",
                            price: 5400,
                          ),
                          SuggestionItem(
                            image: "assets/sug3.png",
                            title: "Coke Studio Bharat Live | Delhi – 2026",
                            location: "Delhi",
                            price: 999,
                          ),
                          SuggestionItem(
                            image: "assets/sug4.jpg",
                            title:
                                "A.R. Rahman - Harmony of Hearts | New Delhi – 2026",
                            location: "New Delhi",
                            price: 5999,
                          ),
                          SuggestionItem(
                            image: "assets/sug5.jpg",
                            title: "Gala-E-Bollywood - The New Year Eve – 2026",
                            location: "Delhi",
                            price: 1499,
                          ),
                          SuggestionItem(
                            image: "assets/sug6.jpg",
                            title:
                                "New Year with Jassie Gill & Babbal Rai – 2026",
                            location: "Delhi",
                            price: 18999,
                          ),
                          SuggestionItem(
                            image: "assets/sug7.jpg",
                            title: "Lucky Ali Live 2026 – 2026",
                            location: "Panchkula",
                            price: 1500,
                          ),
                          SuggestionItem(
                            image: "assets/sug8.jpg",
                            title:
                                "IDFC First Bank Series 2nd T20I: India vs South Africa",
                            location: "Chandigarh",
                            price: 1500,
                          ),
                          SuggestionItem(
                            image: "assets/sug9.jpg",
                            title:
                                "IDFC First Bank Series 4th T20I: India vs South Africa",
                            location: "Lucknow",
                            price: 1500,
                          ),
                          SuggestionItem(
                            image: "assets/sug10.jpg",
                            title:
                                "IDFC First Bank Series 3rd T20I: India vs South Africa",
                            location: "Dharamshala",
                            price: 5000,
                          ),
                          SuggestionItem(
                            image: "assets/sug11.png",
                            title: "Bismil ki Mehfil | Indore",
                            location: "Indore",
                            price: 1249.0,
                          ),
                          SuggestionItem(
                            image: "assets/sug12.jpg",
                            title: "Artbat India Tour | Hyderabad",
                            location: "Hyderabad",
                            price: 2200,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

// ── Location Picker Bottom Sheet ─────────────────────────────────────────────

class _LocationPickerSheet extends StatefulWidget {
  const _LocationPickerSheet({
    required this.currentLocation,
    required this.onUseGPS,
    required this.onLocationSelected,
  });

  final String currentLocation;
  final VoidCallback onUseGPS;
  final ValueChanged<String> onLocationSelected;

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();

  // Popular Indian cities — extend or replace with an API as needed
  final List<String> _allCities = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Kochi",
    "Ernakulam",
    "Chandigarh",
    "Lucknow",
    "Surat",
    "Indore",
    "Bhopal",
    "Nagpur",
    "Coimbatore",
    "Visakhapatnam",
    "Gurgaon",
    "Noida",
    "Bengaluru",
    "Guwahati",
    "Manali",
    "New York",
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _allCities;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredCities = query.isEmpty
          ? _allCities
          : _allCities.where((c) => c.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Title ────────────────────────────────────────────────────────
          const Text(
            "Select Location",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Currently: ${widget.currentLocation}",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // ── Use GPS button ───────────────────────────────────────────────
          InkWell(
            onTap: widget.onUseGPS,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF27A379), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.my_location_rounded,
                      color: Color(0xFF27A379), size: 20),
                  SizedBox(width: 12),
                  Text(
                    "Use my current location",
                    style: TextStyle(
                      color: Color(0xFF27A379),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Search field ─────────────────────────────────────────────────
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search city...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: Colors.grey, size: 20),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Section label ────────────────────────────────────────────────
          const Text(
            "POPULAR CITIES",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),

          // ── City list ────────────────────────────────────────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: _filteredCities.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "No cities found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredCities.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = widget.currentLocation.contains(city);
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        leading: Icon(
                          isSelected
                              ? Icons.location_on
                              : Icons.location_city_outlined,
                          color: isSelected
                              ? const Color(0xFF27A379)
                              : Colors.grey,
                          size: 22,
                        ),
                        title: Text(
                          city,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF27A379)
                                : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF27A379), size: 18)
                            : null,
                        onTap: () => widget.onLocationSelected(city),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
