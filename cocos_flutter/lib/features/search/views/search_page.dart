// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, curly_braces_in_flow_control_structures
import 'package:cocos_flutter/features/product/data/product_dummy.dart';
import 'package:cocos_flutter/features/search/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../product/widgets/product_card.dart';
import '../../product/models/product_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SearchFilters _activeFilters = SearchFilters();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SearchFilters) {
      _activeFilters = args;
    } else if (args is String) {
      // HANDLE KEYWORD FROM HOME CATEGORIES (e.g. '1_', '2_')
      _searchQuery = args;
      _searchController.text = _getDisplayQuery(args);
    }
  }

  // Helper to show a clean name in the search bar if a prefix is used
  String _getDisplayQuery(String query) {
    if (query == '1_') return 'Clothes';
    if (query == '2_') return 'Accessories';
    if (query == '3_') return 'Wigs';
    if (query == '4_') return 'Footwear';
    if (query == '5_') return 'Weapons';
    if (query == 'set_') return 'Sets';
    return query;
  }

  List<ProductModel> _getFilteredProducts(bool isSetTab) {
    return ProductDummyData.products.where((product) {
      // 1. Keyword/SubCategory Match OR Prefix Match (for Home Categories)
      final matchesSearch = _searchQuery.isEmpty ||
          product.subCategory.toLowerCase().contains(_searchQuery.toLowerCase()) || 
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.imagePath.contains(_searchQuery); // Checks for '1_', '2_', etc.

      // 2. Genre (Category) Match - supports multiple genres
      final matchesGenre = !_activeFilters.hasGenreFilter ||
                           _activeFilters.genres.contains(product.category);

      // 3. Wardrobe (Prefix) Match - supports multiple wardrobes
      bool matchesWardrobe = !_activeFilters.hasWardrobeFilter;
      
      if (_activeFilters.hasWardrobeFilter) {
        for (String wardrobe in _activeFilters.wardrobes) {
          String prefix = '';
          if (wardrobe == 'Clothes') prefix = '1_';
          else if (wardrobe == 'Accessories') prefix = '2_';
          else if (wardrobe == 'Wigs') prefix = '3_';
          else if (wardrobe == 'Footwear') prefix = '4_';
          else if (wardrobe == 'Weapons') prefix = '5_';
          else if (wardrobe == 'Sets') prefix = 'set_';
          
          if (prefix.isNotEmpty && product.imagePath.contains(prefix)) {
            matchesWardrobe = true;
            break;
          }
        }
      }

      // 4. Tab Type Match (Costumes vs Sets)
      final isSetAsset = product.imagePath.contains('set_');
      final matchesTab = isSetTab ? isSetAsset : !isSetAsset;

      return matchesSearch && matchesGenre && matchesWardrobe && matchesTab;
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: AppColors.navHeaderBackground,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.nunito(color: Colors.white),
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search costumes, characters...',
              hintStyle: GoogleFonts.nunito(color: Colors.white54, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF8B5CF6),
            labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.nunito(),
            tabs: const [
              Tab(text: 'Costumes'),
              Tab(text: 'Sets'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(false), // Costumes (1_ to 5_)
                _buildProductGrid(true),  // Sets (set_)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(bool isSet) {
    final filteredList = _getFilteredProducts(isSet);
    
    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No items found for "${_getDisplayQuery(_searchQuery)}"'
                  : 'No items match your filters',
              style: GoogleFonts.nunito(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final product = filteredList[index];
        return ProductCard(
          imagePath: product.imagePath,
          name: product.name,
          rating: product.rating,
          sold: '50+ Sold',
          price: product.price.toString(),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: product,
          ),
        );
      },
    );
  }
}
