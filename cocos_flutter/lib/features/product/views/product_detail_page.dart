import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../models/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedVersionIndex = 0;
  String? _selectedMaterial;
  String? _selectedSize;
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  }

  @override
  void dispose() {
    _scaffoldMessenger?.removeCurrentSnackBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aman: ambil argumen dengan pengecekan null
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! ProductModel) {
      // Tampilkan layar error
      return Scaffold(
        backgroundColor: AppColors.mainBackground,
        appBar: CustomAppBar(
          title: 'Error',
          showBackButton: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 64),
              const SizedBox(height: 16),
              Text(
                'Product not found',
                style: GoogleFonts.nunito(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final product = args;
    
    // Inisialisasi nilai default pada build pertama
    _selectedMaterial ??= product.materials.isNotEmpty ? product.materials[0] : null;
    _selectedSize ??= product.sizes.isNotEmpty ? product.sizes[0] : null;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: CustomAppBar(
        title: product.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR PRODUK ---
            Container(
              height: 520,
              width: 450,
              decoration: BoxDecoration(
                color: Colors.black12,
                image: DecorationImage(
                  image: AssetImage(product.imagePath), 
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HARGA ---
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // --- NAMA & KATEGORI PRODUK ---
                  Text(
                    product.name,
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.category} - ${product.subCategory}',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- PENILAIAN ---
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white10),
                  ),

                  // --- WARNA / VERSI ---
                  _buildSectionTitle('Color / Version'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(product.availableVersions.length, (index) {
                        bool isSelected = _selectedVersionIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedVersionIndex = index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                                width: 2,
                              ),
                              color: Colors.white10,
                            ),
                            child: Center(
                              child: Text(
                                product.availableVersions[index],
                                style: GoogleFonts.nunito(
                                  color: isSelected ? Colors.white : Colors.white38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- PEMILIHAN MATERIAL ---
                  _buildSectionTitle('Material'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: product.materials.map((mat) {
                      final bool isSelected = _selectedMaterial == mat;
                      return ChoiceChip(
                        label: Text(mat),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedMaterial = mat),
                        backgroundColor: Colors.white10,
                        selectedColor: const Color(0xFF8B5CF6),
                        labelStyle: GoogleFonts.nunito(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // --- PEMILIHAN UKURAN ---
                  _buildSectionTitle('Size'),
                  const SizedBox(height: 12),
                  Row(
                    children: product.sizes.map((size) {
                      final bool isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFF8B5CF6) : Colors.white10,
                            border: Border.all(
                              color: isSelected ? Colors.transparent : Colors.white24,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: GoogleFonts.nunito(
                                color: isSelected ? Colors.white : Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // --- DESKRIPSI ---
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: GoogleFonts.nunito(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- KOMENTAR ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Comments'),
                      Text(
                        'See All',
                        style: GoogleFonts.nunito(color: const Color(0xFF8B5CF6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildReviewItem(
                    'Cosplayer_Pro',
                    'The quality is amazing, definitely worth the price!',
                    'assets/logo_images/water_profile.jpg', 
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionPanel(
        product,
        _selectedSize,
        _selectedMaterial,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildReviewItem(String name, String comment, String avatarPath) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white10,
          backgroundImage: AssetImage(avatarPath),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: GoogleFonts.nunito(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionPanel(
    ProductModel product,
    String? selectedSize,
    String? selectedMaterial,
  ) {
    void addToCart(BuildContext context) {
      final userId = context.read<AuthProvider>().user?.id ?? 'guest_user';
      context.read<CartProvider>().addItem(
        userId,
        product,
        selectedSize ?? (product.sizes.isNotEmpty ? product.sizes.first : 'M'),
        selectedMaterial ?? (product.materials.isNotEmpty ? product.materials.first : 'Standard'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Tombol chat
            GestureDetector(
              onTap: () => AppRoutes.goToChat(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 16),
            // Tombol tambah ke keranjang
            IconButton(
              onPressed: () {
                addToCart(context);
                
                // Perbaikan: hapus SnackBar yang ada terlebih dahulu
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                
                // Kemudian tampilkan SnackBar baru
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.name} added to cart',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    backgroundColor: AppColors.navHeaderBackground,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: AppColors.textPrimary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        AppRoutes.goToCart(context);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            // Tombol checkout
            Expanded(
              child: CustomButton(
                text: 'Checkout',
                color: AppColors.primary,
                onPressed: () {
                  addToCart(context);
                  AppRoutes.goToCheckout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}