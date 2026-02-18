import 'package:flutter/material.dart';

class CancelBookingPage extends StatefulWidget {
  const CancelBookingPage({super.key});

  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage>
    with SingleTickerProviderStateMixin {
  int selectedReason = -1;
  bool showSuccess = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<String> reasons = [
    "I have a better deal",
    "Some other work, can’t come",
    "I want to book another event",
    "Venue location is too far",
    "Another reason",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccess();
            },
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    setState(() => showSuccess = true);
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context, true); 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccess) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 100),
                SizedBox(height: 16),
                Text(
                  "Booking Cancelled",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title:
            const Text("Cancel Booking", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please select the reason for cancellation",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...List.generate(reasons.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selectedReason,
                title: Text(reasons[index]),
                onChanged: (v) => setState(() => selectedReason = v!),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedReason == -1 ? null : _showConfirmDialog,
                child: const Text("Cancel Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
