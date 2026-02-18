import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/login_page.dart';
import 'package:mainproject/feature/featurdemo/auth/presentation/screen/onboarding_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();
  bool islastpage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 50),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                islastpage = index == 3;
              });
            },
            children: [
              buildimagecontainer(
                  Colors.white,
                  'welcome to Evex',
                  'Your gateway to unforgettable events and effortless management With Evex, discovering and hosting events becomes beautifully simple.',
                  'assets/event1.png'),
              buildimagecontainer(
                  Colors.white,
                  'Every great night starts with one ticket',
                  'Find, book, and enjoy events with ease. Your ultimate companion for seamless event experiences.',
                  'assets/event2.png'),
              buildimagecontainer(
                  Colors.white,
                  'Bring people together Well handle the rest',
                  'Host events confidently while Evex manages everything behind the scenes—smooth, smart, and stress-free.',
                  'assets/event3.png'),
              buildimagecontainer(
                  Colors.white,
                  'Host boldly Book instantly Celebrate endlessly',
                  'Plan events, sell tickets, and connect with your audience—all in one powerful platform.',
                  'assets/event4.png'),
            ],
          ),
        ),
        bottomSheet: islastpage
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: const Color(0xFFF2D27A),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 24),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //text button skip
                    TextButton(
                      onPressed: () {
                        controller.jumpToPage(3);
                      },
                      child: Text("Skip",
                          style: TextStyle(
                              color: const Color(0xFF1E293B), fontSize: 18)),
                    ),

                    //page indicator
                    Center(
                      child: SmoothPageIndicator(
                        effect: WormEffect(
                          spacing: 5,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: const Color(0xFFF2D27A),
                          activeDotColor: const Color(0xFFE1BC4E),
                        ),
                        onDotClicked: (index) {
                          controller.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        controller: controller,
                        count: 4,
                      ),
                    ),

                    //text button next
                    TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: Duration(milliseconds: 600),
                            curve: Curves.easeInOut);
                      },
                      child: Text("Next",
                          style: TextStyle(
                              color: const Color(0xFF1E293B), fontSize: 18)),
                    ),
                  ],
                ),
              ));
  }
}
