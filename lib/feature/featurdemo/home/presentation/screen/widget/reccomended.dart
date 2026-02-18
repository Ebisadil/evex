import 'package:flutter/material.dart';
import 'package:mainproject/core/widgets/fixed_image.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/order_detail_page.dart';

class ReccomendedEvent extends StatelessWidget {
  final String image;
  final String category;
  final String hostName;
  final String title;
  final String dateRange;
  final double price;
  final List<String> attendees;
  final String hostImage;

  const ReccomendedEvent({
    super.key,
    required this.image,
    required this.category,
    required this.hostName,
    required this.title,
    required this.dateRange,
    required this.price,
    required this.attendees,
    required this.hostImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),

      //  FULL CARD CLICKABLE
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailPage(
                image: image,
                title: title,
                location: "Kochi, Kerala",
                price: price,
                latitude: 9.9312,
                longitude: 76.2673,
                date: '',
                category: '',
              ),
            ),
          );
        },
        child: Container(
          width: 350,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFF2D27A),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // IMAGE SECTION
              SizedBox(
                height: 170,
                width: double.infinity,
                child: Stack(
                  children: [
                    FixedBoxImage(
                      imagePath: image,
                      height: 170,
                      width: double.infinity,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFFF2D27A),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: AssetImage(hostImage),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hostName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(blurRadius: 4, color: Colors.black)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // DETAILS
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 32,
                          width: 120,
                          child: Stack(
                            children: List.generate(attendees.length, (index) {
                              return Positioned(
                                left: index * 20,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(Icons.person, size: 16),
                                ),
                              );
                            }),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1BC4E),
                            borderRadius:
                                BorderRadius.circular(14), //0xFFF2D27A
                          ),
                          child: Text(
                            price.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Color.fromARGB(
                                  255, 249, 248, 247), //0xFFE1BC4E
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }
}
