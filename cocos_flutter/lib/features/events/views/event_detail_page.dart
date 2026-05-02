import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
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
        actions: [
          _buildAppBarAction(Icons.share_outlined),
          _buildAppBarAction(Icons.favorite_outline_rounded),
        ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Recommended Sets'),
                      Text(
                        'Explore All',
                        style: GoogleFonts.nunito(
                          color: AppColors.eventAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRecommendationGrid(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildStickyBottomAction(),
    );
  }

  Widget _buildAppBarAction(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: () {},
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
        const SizedBox(width: 12),
        _buildInfoCard(Icons.phone_outlined, 'CONTACT', 'Support Team'),
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
    List<Map<String, String>> recommendations = [];
    String cat = event.category.toLowerCase();
    
    if (cat.contains('anime') || cat.contains('matsuri')) {
      recommendations = [
        {'name': 'One Piece Set', 'price': '\$299.00', 'img': 'assets/product_images/anime_images/onepiece_images/set_onepiece.png'},
        {'name': 'Demon Slayer Set', 'price': '\$249.00', 'img': 'assets/product_images/anime_images/demonslayer_images/set_demonslayer.png'},
      ];
    } else if (cat.contains('game')) {
      recommendations = [
        {'name': 'Genshin Impact Set', 'price': '\$350.00', 'img': 'assets/product_images/game_images/genshin_images/set_genshin.png'},
        {'name': 'Elden Ring Set', 'price': '\$420.00', 'img': 'assets/product_images/game_images/eldenring_images/set_eldenring.png'},
      ];
    } else {
      recommendations = [
        {'name': 'Harry Potter Set', 'price': '\$189.00', 'img': 'assets/product_images/film_images/harrypott_images/set_harrypott.png'},
        {'name': 'Star Wars Set', 'price': '\$399.00', 'img': 'assets/product_images/film_images/starwars_images/set_starwars.png'},
      ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75, // Optimized ratio for full costumes
      ),
      itemBuilder: (context, index) {
        final char = recommendations[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8), // Reduced margin to fit better
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(char['img']!),
                      fit: BoxFit.contain, // Full visibility of faces and costumes
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                child: Text(
                  char['name']!,
                  style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Text(
                  char['price']!,
                  style: GoogleFonts.nunito(color: AppColors.eventAccent, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.mainBackground,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navHeaderBackground,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Book Your Tickets',
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
Size: const Size.fromHeight(56)