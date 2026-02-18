import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/cart_page.dart';

class EventSchedulePage extends StatelessWidget {
  const EventSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Schedule")),
      body: const Center(child: Text("Schedule & Timeline")),
    );
  }
}

class EventDetailPage extends StatefulWidget {
  final String image;
  final String title;
  final String date;
  final String location;
  final double price;
  final String category;

  const EventDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.category,
   
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final ScrollController _scrollController = ScrollController();

  bool _showTitle = false;
  bool _isExpanded = false;

  static const double _expandedHeight = 260;

  final List<Map<String, dynamic>> whyEventData = [
    {
      "icon": Icons.workspace_premium,
      "title": "Premium Experience",
      "desc": "India’s biggest pop culture celebration comes to Kochi",
    },
    {
      "icon": Icons.person,
      "title": "Celebrity Guests",
      "desc": "Meet famous creators, actors, and influencers live",
    },
    {
      "icon": Icons.emoji_events,
      "title": "Fun Activities",
      "desc": "Cosplay contests, gaming zones, and exclusive merch",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showTitle = _scrollController.offset > 180;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _sliverHeader(),
              SliverToBoxAdapter(child: _content()),
            ],
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  // ================= SLIVER HEADER =================
  Widget _sliverHeader() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: _expandedHeight,
      pinned: true,
      elevation: 0,
      leading: _circleIcon(Icons.arrow_back, () => Navigator.pop(context)),
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showTitle ? 1 : 0,
        child: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          widget.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= PAGE CONTENT =================
  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chip(widget.category),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(widget.date, style: const TextStyle(color: Colors.amber)),
          const SizedBox(height: 16),
          _infoTile(Icons.location_on_outlined, widget.location, "View on map"),
          _infoTile(
            Icons.schedule,
            "Gates open 30 minutes before start",
            "View full schedule & timeline",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EventSchedulePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _mapPreview(),
          const SizedBox(height: 24),
          _whyThisEventHorizontalCards(),
          const SizedBox(height: 28),
          _aboutEventSection(
            "Kochi, get ready! Comic Con is coming to your city for the very first time. "
            "Step into a world of fandom with celebrity sessions, epic cosplay, "
            "exclusive merch, gaming zones, and more.",
          ),
          const SizedBox(height: 28),
          _thingsToKnowSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // ================= HORIZONTAL CARDS =================
  Widget _whyThisEventHorizontalCards() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: whyEventData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = whyEventData[index];
          return _whyCard(
            icon: item["icon"],
            title: item["title"],
            description: item["desc"],
          );
        },
      ),
    );
  }

  Widget _whyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ================= ABOUT EVENT =================
  Widget _aboutEventSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About the event",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(description),
        ),
        TextButton(
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          child: Text(_isExpanded ? "Read less ▲" : "Read more ›"),
        ),
      ],
    );
  }

  // ================= MAP =================
  Widget _mapPreview() {
    return SizedBox(
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(9.9312, 76.2673),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId("venue"),
              position: LatLng(9.9312, 76.2673),
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }

  // ================= THINGS TO KNOW =================
  Widget _thingsToKnowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Things to Know",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _Thing(Icons.language, "Event will be in English, Hindi"),
        _Thing(Icons.confirmation_number, "Ticket needed for ages 3+"),
        _Thing(Icons.event_available, "Entry allowed for all ages"),
        _Thing(Icons.family_restroom, "Kid friendly"),
      ],
    );
  }

  // ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF2D27A),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.price} onwards",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartReviewScreen(
                      image: '',
                      title: '',
                      date: '',
                      price: widget.price,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFF2D27A),
              ),
              child: const Text("Book tickets"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SMALL WIDGETS =================
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: const Color.fromARGB(255, 172, 172, 172)),
      ),
    );
  }
}

/// ---------------- THING ITEM ----------------
class _Thing extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Thing(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
