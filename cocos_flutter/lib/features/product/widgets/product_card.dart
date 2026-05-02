import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final double rating;
  final String sold;
  final String price;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.rating,
    required this.sold,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  image: DecorationImage(
                    // --- DYNAMIC: PRODUCT IMAGE PATH ---
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: GoogleFonts.nunito(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '| $sold',
                        style: GoogleFonts.nunito(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$$price',
                    style: GoogleFonts.nunito(
                      color: const Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
