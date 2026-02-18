import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/favourite/presantation/screen/favourites.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/home_tab.dart';
import 'package:mainproject/feature/featurdemo/setting/presantation/screen/profile.dart';
import 'package:mainproject/feature/featurdemo/tickets/presantation/screen/tickets.dart';
import 'package:mainproject/feature/profile/preantation/screen/profile.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    NewHomeTab(),
    TicketManagementScreen(
      image: '',
      title: '',
      venue: '',
      dateTime: '',
      ticketRef: '',
      bookingRef: '',
    ),
    MainSettingsHub(),
    Settings(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF2D27A),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        showUnselectedLabels: true,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            label: "Tickets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settins",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
