import 'package:flutter/material.dart';
import 'package:mainproject/core/widgets/fixed_image.dart';

import 'order_detail_page.dart';

class SuggestionItem extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final double price;
  final double latitude;
  final double longitude;

  const SuggestionItem({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    this.latitude = 28.7041,
    this.longitude = 77.1025,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              image: image,
              title: title,
              location: location,
              price: price,
              latitude: latitude,
              longitude: longitude,
              date: '',
              category: '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 11,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 251, 230, 173),
              blurRadius: 6,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            FixedBoxImage(
              imagePath: image,
              height: 80,
              width: 80,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Expanded(child: Text(location)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF2D27A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₹${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
