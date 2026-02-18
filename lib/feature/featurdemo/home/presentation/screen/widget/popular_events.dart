import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/eventcard.dart';
import 'order_detail_page.dart';

class PopularEvents extends StatelessWidget {
  const PopularEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Popular Events",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // EVENT SLIDER
          _eventCardSlider(),
        ],
      ),
    );
  }
}

Widget _eventCardSlider() {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> events = [
    {
      "image": "assets/party1.jpg",
      "date": "Sun, 28 Dec • 4:00 PM – Mon, 29 Dec • 3:00 AM",
      "title": "Summer party | Goa",
      "location": "Goa",
      "price": "₹750",
      "category": "party"
    },
    {
      "image": "assets/party2.jpg",
      "date": "Fri, 1 Jan • 7:00 PM",
      "title": "Summer Night",
      "location": "Mumbai",
      "price": "₹999",
      "category": "music"
    },
    {
      "image": "assets/party4.jpg",
      "date": "Sat, 14 Feb • 6:00 PM",
      "title": "Valentine Concert",
      "location": "Delhi",
      "price": "₹499",
      "category": "concert"
    },
    {
      "image": "assets/party3.jpg",
      "date": "Sat, 24 Dec • 6:00 PM",
      "title": "Music Event",
      "location": "Agra",
      "price": "₹750",
      "category": "music"
    },
    {
      "image": "assets/party5.jpg",
      "date": "Sat, 30 Dec • 12:00 AM",
      "title": "New Year Celebration",
      "location": "Kochi",
      "price": "₹999",
      "category": "party"
    },
  ];

  return SizedBox(
    height: 360,
    width: double.infinity,
    child: PageView.builder(
      controller: _pageController,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;

            if (_pageController.position.haveDimensions) {
              value = (_pageController.page! - index).abs();
              value = (1 - value * 0.25).clamp(0.85, 1.0);
            }

            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: EventCard(
            image: events[index]["image"]!,
            date: events[index]["date"]!,
            title: events[index]["title"]!,
            location: events[index]["location"]!,
            price: events[index]["price"]!,
            category: events[index]["category"]!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailPage(
                    image: events[index]["image"]!,
                    date: events[index]["date"]!,
                    title: events[index]["title"]!,
                    location: events[index]["location"]!,
                    price: double.parse(
                      events[index]["price"]!.replaceAll("₹", "").trim(),
                    ),
                    category: events[index]["category"]!,
                    latitude: 9.9312,
                    longitude: 76.2673,
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
