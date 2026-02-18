import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Placeholder for ViewPassPage (replace with your real screen)
class ViewPassPage extends StatelessWidget {
  final String image;
  final String title;
  final String venue;
  final String dateTime;
  final String ticketRef;
  final String bookingRef;

  const ViewPassPage({
    super.key,
    required this.image,
    required this.title,
    required this.venue,
    required this.dateTime,
    required this.ticketRef,
    required this.bookingRef,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Pass')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ticket: $title', style: const TextStyle(fontSize: 24)),
            Text('Ref: $ticketRef'),
            Text('Venue: $venue • $dateTime'),
          ],
        ),
      ),
    );
  }
}

// Booked Ticket Model
class BookedTicket {
  final String image;
  final String title;
  final String venue;
  final String attendee;
  final String dateTime;
  final String ticketRef;
  final String bookingRef;
  final String status;

  BookedTicket({
    required this.image,
    required this.title,
    required this.venue,
    required this.attendee,
    required this.dateTime,
    required this.ticketRef,
    required this.bookingRef,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'venue': venue,
        'attendee': attendee,
        'dateTime': dateTime,
        'ticketRef': ticketRef,
        'bookingRef': bookingRef,
        'status': status,
      };

  factory BookedTicket.fromJson(Map<String, dynamic> json) => BookedTicket(
        image: json['image'] as String,
        title: json['title'] as String,
        venue: json['venue'] as String,
        attendee: json['attendee'] as String,
        dateTime: json['dateTime'] as String,
        ticketRef: json['ticketRef'] as String,
        bookingRef: json['bookingRef'] as String,
        status: json['status'] as String,
      );
}

class TicketManagementScreen extends StatefulWidget {
  const TicketManagementScreen(
      {super.key,
      required String image,
      required String title,
      required String venue,
      required String dateTime,
      required String ticketRef,
      required String bookingRef});

  @override
  State<TicketManagementScreen> createState() => _TicketManagementScreenState();
}

class _TicketManagementScreenState extends State<TicketManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSuccessBanner = false;
  List<BookedTicket> _bookedTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookedTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookedTickets() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('booked_tickets') ?? [];
    setState(() {
      _bookedTickets = jsonList
          .map((jsonStr) => BookedTicket.fromJson(jsonDecode(jsonStr)))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Tickets',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFE1BC4E)),
            onPressed: _loadBookedTickets,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Success Banner (demo toggle)
                AnimatedOpacity(
                  opacity: _showSuccessBanner ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showSuccessBanner ? 100 : 0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3A4A2A), Color(0xFF1A2A0A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFFE1BC4E).withOpacity(0.2),
                            blurRadius: 12),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Color(0xFFD4AF37), size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Booking Confirmed!',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your ticket is ready — check Active tab',
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () =>
                              setState(() => _showSuccessBanner = false),
                        ),
                      ],
                    ),
                  ),
                ),

                // Glass Tab Bar
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15), blurRadius: 20)
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFFE1BC4E).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: const Color(0xFFE1BC4E),
                    unselectedLabelColor: Colors.white70,
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Booked'),
                      Tab(text: 'Active'),
                      Tab(text: 'Expired'),
                      Tab(text: 'Refunded'),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookedTab(),
                      _buildActiveTab(),
                      _buildExpiredTab(),
                      _buildRefundedTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1BC4E),
        onPressed: () =>
            setState(() => _showSuccessBanner = !_showSuccessBanner),
        child: Icon(
          _showSuccessBanner ? Icons.close : Icons.celebration,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBookedTab() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE1BC4E)));
    }

    if (_bookedTickets.isEmpty) {
      return _buildEmptyState("No booked tickets yet", Icons.event_busy);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookedTickets.length,
      itemBuilder: (context, index) {
        final ticket = _bookedTickets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPassPage(
                    image: ticket.image,
                    title: ticket.title,
                    venue: ticket.venue,
                    dateTime: ticket.dateTime,
                    ticketRef: ticket.ticketRef,
                    bookingRef: ticket.bookingRef,
                  ),
                ),
              );
            },
            child: BookedTicketCard(
              image: ticket.image,
              title: ticket.title,
              venue: ticket.venue,
              attendee: ticket.attendee,
              dateTime: ticket.dateTime,
              ticketRef: ticket.ticketRef,
              bookingRef: ticket.bookingRef,
              status: ticket.status,
              statusColor: const Color(0xFFE1BC4E),
              gradientColors: const [Color(0xFF4A3A2A), Color(0xFF1A120A)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveTab() {
    return _buildEmptyState(
        "No active tickets right now", Icons.hourglass_empty);
  }

  Widget _buildExpiredTab() {
    return _buildEmptyState("No expired tickets", Icons.event_busy);
  }

  Widget _buildRefundedTab() {
    return _buildEmptyState("No refunded tickets", Icons.money_off);
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Minimal BookedTicketCard (replace with your full version)
class BookedTicketCard extends StatelessWidget {
  final String image;
  final String title;
  final String venue;
  final String attendee;
  final String dateTime;
  final String ticketRef;
  final String bookingRef;
  final String status;
  final Color statusColor;
  final List<Color> gradientColors;

  const BookedTicketCard({
    super.key,
    required this.image,
    required this.title,
    required this.venue,
    required this.attendee,
    required this.dateTime,
    required this.ticketRef,
    required this.bookingRef,
    required this.status,
    required this.statusColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image,
                  height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text("Venue: $venue",
                style: const TextStyle(color: Colors.white70)),
            Text("Attendee: $attendee",
                style: const TextStyle(color: Colors.white70)),
            Text("Date: $dateTime",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status,
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold)),
                Text(ticketRef, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
