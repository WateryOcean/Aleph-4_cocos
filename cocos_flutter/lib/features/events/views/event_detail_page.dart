import 'package:cocos_flutter/features/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../product/models/product_model.dart';
import '../../product/widgets/product_card.dart';
import '../models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTagAndDate(),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInfoGrid(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('About Event'),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: GoogleFonts.nunito(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSectionTitle('Recommended Sets'),
                  const SizedBox(height: 24),
                  _buildRecommendationGrid(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            event.imageUrl,
            fit: BoxFit.contain, 
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.white10,
              child: const Icon(Icons.broken_image, color: Colors.white24, size: 60),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.mainBackground],
                stops: [0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagAndDate() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: event.accentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.category.toUpperCase(),
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '•  ${event.date}',
          style: GoogleFonts.nunito(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        _buildInfoCard(Icons.location_on_outlined, 'LOCATION', event.location.split(',').first),
        const SizedBox(width: 12),
        _buildInfoCard(Icons.access_time_outlined, 'TIME', event.time.split(' - ').first),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.eventAccent, size: 24),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.nunito(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRecommendationGrid(BuildContext context) {
    final allProducts = context.watch<ProductProvider>().products;

    // 1. Ambil produk yang cocok dengan kategori atau mengandung 'set_'
    List<ProductModel> matchingProducts = allProducts.where((p) {
      String cat = event.category.toLowerCase();
      return p.category.toLowerCase().contains(cat) || p.imagePath.contains('set_');
    }).toList();

    // 2. Fallback ke produk umum jika tidak ada yang cocok
    if (matchingProducts.isEmpty) {
      matchingProducts = List.from(allProducts);
    }

    // 3. Acak untuk memastikan variasi, lalu ambil 2 teratas
    matchingProducts.shuffle();
    final List<ProductModel> recommendations = matchingProducts.take(2).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = recommendations[index];
        return ProductCard(
          imagePath: product.imagePath,
          name: product.name,
          rating: product.rating,
          sold: 'Featured', 
          price: product.price.toStringAsFixed(2),
          onTap: () => AppRoutes.goToProductDetail(context, product),
        );
      },
    );
  }
}
