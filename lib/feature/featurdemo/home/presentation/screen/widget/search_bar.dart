import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/suggestion_item.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/upcoming.dart';

import 'order_detail_page.dart';

class HomeTabSearchBar extends StatelessWidget {
  const HomeTabSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.tune),
            hintText: "Search",
            fillColor: const Color.fromARGB(255, 213, 213, 213),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 213, 213, 213),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const CategoryTabsView(),
      ],
    );
  }
}

class CategoryTabsView extends StatelessWidget {
  const CategoryTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryList.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => category["page"],
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Icon(category["icon"], size: 18),
                    const SizedBox(width: 6),
                    Text(category["label"]),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryTab({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 213, 213, 213),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> categoryList = [
  {
    "icon": Icons.music_note,
    "label": "Music",
    "page": const MusicPage(),
  },
  {
    "icon": Icons.school,
    "label": "Education",
    "page": const EducationPage(),
  },
  {
    "icon": Icons.theater_comedy,
    "label": "Film & Art",
    "page": const FilmArtPage(),
  },
  {
    "icon": Icons.sports,
    "label": "Sports",
    "page": const SportsPage(),
  },
];

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Page: $title',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

class FilmArtPage extends StatelessWidget {
  const FilmArtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Film & Art")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SuggestionItem(
            image: "assets/sug12.jpg",
            title: "Artbat India Tour | Hyderabad",
            location: "Hyderabad",
            price: 2200.0,
          ),
          SuggestionItem(
            image: "assets/sug11.png",
            title: "Bismil ki Mehfil | Indore",
            location: "Indore",
            price: 1249.0,
          ),
        ],
      ),
    );
  }
}

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Music")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SuggestionItem(
            image: "assets/sug2.jpg",
            title:
                "Songs of the Stone | Musical Experience at Qutub Minar – 2026",
            location: "Qutub Minar, Delhi",
            price: 5400.0,
          ),
          const SuggestionItem(
            image: "assets/sug3.png",
            title: "Coke Studio Bharat Live | Delhi – 2026",
            location: "Delhi",
            price: 999.0,
          ),
          const SuggestionItem(
            image: "assets/sug4.jpg",
            title: "A.R. Rahman - Harmony of Hearts | New Delhi – 2026",
            location: "New Delhi",
            price: 5999.0,
          ),
          const SuggestionItem(
            image: "assets/sug5.jpg",
            title: "Gala-E-Bollywood - The New Year Eve – 2026",
            location: "Delhi",
            price: 1499.0,
          ),
          const SuggestionItem(
            image: "assets/sug6.jpg",
            title: "New Year with Jassie Gill & Babbal Rai – 2026",
            location: "Delhi",
            price: 18999.0,
          ),
          const SuggestionItem(
            image: "assets/sug7.jpg",
            title: "Lucky Ali Live 2026",
            location: "Panchkula",
            price: 1500.0,
          ),
        ],
      ),
    );
  }
}

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Education")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          upcomingEventCard(
            image: "assets/upcoming2.jpg",
            title: "Mentalist Mega Festival 2026",
            location: "Kochi",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EventDetailPage(
                          image: "assets/upcoming2.jpg",
                          title: "Mentalist Mega Festival 2026",
                          location: "Kochi",
                          date: '15',
                          price: 1500.0,
                          category: 'Entertainment',
                          latitude: 9.9312,
                          longitude: 76.2673)));
            },
          ),
          upcomingEventCard(
            image: "assets/upcoming6.jpg",
            title: "Chess Tournament With Artificial Intelligence (AI)",
            location: "Delhi",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EventDetailPage(
                          image: "assets/upcoming6.jpg",
                          title:
                              "Chess Tournament With Artificial Intelligence (AI)",
                          location: "Delhi",
                          date: '20',
                          price: 2500.0,
                          category: 'Sports',
                          latitude: 9.9312,
                          longitude: 76.2673)));
            },
          ),
        ],
      ),
    );
  }
}

class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sports")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SuggestionItem(
            image: "assets/sug8.jpg",
            title: "IDFC First Bank Series 2nd T20I: India vs South Africa",
            location: "Chandigarh",
            price: 1500.0,
          ),
          const SuggestionItem(
            image: "assets/sug9.jpg",
            title: "IDFC First Bank Series 4th T20I: India vs South Africa",
            location: "Lucknow",
            price: 1500.0,
          ),
          const SuggestionItem(
            image: "assets/sug10.jpg",
            title: "IDFC First Bank Series 3rd T20I: India vs South Africa",
            location: "Dharamshala",
            price: 5000.0,
          ),
          upcomingEventCard(
            image: "assets/upcoming4.jpg",
            title: "SPACETECH FESTIVAL WINTER EDITION",
            location: "Manali",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EventDetailPage(
                          image: "assets/upcoming4.jpg",
                          title: "SPACETECH FESTIVAL WINTER EDITION",
                          location: "Manali",
                          date: '15',
                          price: 5000.0,
                          category: 'Technology',
                          latitude: 9.9312,
                          longitude: 76.2673)));
            },
          ),
        ],
      ),
    );
  }
}
