// lib/features/home/views/home_page.dart
// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use
import 'package:cocos_flutter/features/auth/data/auth_dummy.dart';
import 'package:cocos_flutter/features/product/data/product_dummy.dart';
import 'package:cocos_flutter/features/product/widgets/product_card.dart';
import 'package:cocos_flutter/features/search/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_navbar.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedPopularFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  
  List<String> _selectedGenres = [];
  List<String> _selectedWardrobes = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC: CATEGORY NAVIGATION (Updated for Prefix Keywords) ---
  void _onCategoryPressed(String category) {
    String prefix = '';
    if (category == 'Clothes') {
      prefix = '1_';
    } else if (category == 'Accessories') {
      prefix = '2_';
    } else if (category == 'Wigs') {
      prefix = '3_';
    } else if (category == 'Footwear') {
      prefix = '4_';
    }

    // Navigates to search page using the asset prefix as the keyword
    AppRoutes.goToSearch(context, keyword: prefix);
  }

  void _showFilterModal() {
    List<String> tempGenres = List.from(_selectedGenres);
    List<String> tempWardrobes = List.from(_selectedWardrobes);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mainBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Genre',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Anime', 'Film', 'Game'].map((genre) {
                      final isSelected = genre == 'All' 
                        ? tempGenres.isEmpty 
                        : tempGenres.contains(genre);
                      return _buildFilterChipModal(
                        genre,
                        isSelected,
                        () {
                          setModalState(() {
                            if (genre == 'All') {
                              tempGenres.clear();
                            } else {
                              if (isSelected) {
                                tempGenres.remove(genre);
                              } else {
                                tempGenres.add(genre);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Wardrobe',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Clothes', 'Accessories', 'Wigs', 'Footwear', 'Weapons', 'Sets']
                        .map((wardrobe) {
                      final isSelected = wardrobe == 'All' 
                        ? tempWardrobes.isEmpty 
                        : tempWardrobes.contains(wardrobe);
                      return _buildFilterChipModal(
                        wardrobe,
                        isSelected,
                        () {
                          setModalState(() {
                            if (wardrobe == 'All') {
                              tempWardrobes.clear();
                            } else {
                              if (isSelected) {
                                tempWardrobes.remove(wardrobe);
                              } else {
                                tempWardrobes.add(wardrobe);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempGenres.clear();
                              tempWardrobes.clear();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8B5CF6)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.nunito(
                              color: const Color(0xFF8B5CF6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedGenres = List.from(tempGenres);
                              _selectedWardrobes = List.from(tempWardrobes);
                            });
                            Navigator.pop(context);
                            
                            final filters = SearchFilters(
                              genres: tempGenres,
                              wardrobes: tempWardrobes,
                            );
                            Navigator.pushNamed(
                              context,
                              AppRoutes.search,
                              arguments: filters,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthDummyData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: AppColors.navHeaderBackground,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              // AppRoutes.goToProfile(context);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white24,
              backgroundImage: AssetImage(user.profilePicture),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70),
            ),
            Text(
              user.fullName,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.nunito(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search costumes, props...',
                          hintStyle: GoogleFonts.nunito(color: Colors.white38),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white38,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty)
                            AppRoutes.goToSearch(context, keyword: value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionHeader(
              'Special Offers',
              () => AppRoutes.goToSpecialOffers(context),
            ),
            SizedBox(
              height: 180,
              child: PageView(
                children: [
                  _buildOfferCard('assets/offer_images/offer_1.png'),
                  _buildOfferCard('assets/offer_images/offer_2.png'),
                  _buildOfferCard('assets/offer_images/offer_3.png'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem(
                    Icons.checkroom_rounded,
                    'Clothes',
                    () => _onCategoryPressed('Clothes'),
                  ),
                  _buildCategoryItem(
                    Icons.auto_fix_high_rounded,
                    'Accessories',
                    () => _onCategoryPressed('Accessories'),
                  ),
                  _buildCategoryItem(
                    Icons.face_retouching_natural_rounded,
                    'Wigs',
                    () => _onCategoryPressed('Wigs'),
                  ),
                  _buildCategoryItem(
                    Icons.shopping_bag_rounded,
                    'Footwear',
                    () => _onCategoryPressed('Footwear'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Most Popular',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Clothes'),
                  _buildFilterChip('Accessories'),
                  _buildFilterChip('Wigs'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _getFilteredIndices().length,
                itemBuilder: (context, index) {
                  int productIndex = _getFilteredIndices()[index];
                  return _buildDynamicProductCard(context, productIndex);
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  List<int> _getFilteredIndices() {
    List<int> baseIndices = [0, 1, 14, 24, 37, 59];
    if (_selectedPopularFilter == 'All') return baseIndices;

    String prefix = '';
    if (_selectedPopularFilter == 'Clothes') {
      prefix = '1_';
    } else if (_selectedPopularFilter == 'Accessories')
      prefix = '2_';
    else if (_selectedPopularFilter == 'Wigs')
      prefix = '3_';

    return baseIndices.where((idx) {
      if (idx >= ProductDummyData.products.length) return false;
      return ProductDummyData.products[idx].imagePath.contains(prefix);
    }).toList();
  }

  Widget _buildDynamicProductCard(BuildContext context, int index) {
    if (index >= ProductDummyData.products.length)
      return const SizedBox.shrink();
    final product = ProductDummyData.products[index];
    return ProductCard(
      imagePath: product.imagePath,
      name: product.name,
      rating: product.rating,
      sold: '124 Sold',
      price: product.price.toString(),
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.productDetail,
        arguments: product,
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'See All',
              style: GoogleFonts.nunito(color: const Color(0xFF8B5CF6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedPopularFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPopularFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChipModal(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}