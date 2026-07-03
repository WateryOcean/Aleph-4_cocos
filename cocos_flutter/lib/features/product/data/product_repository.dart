import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../models/product_model.dart';
 
class ProductRepository {

  ProductRepository._();

  static final ProductRepository instance = ProductRepository._();
 
  /// Mengambil data produk dari npoint API
  Future<List<ProductModel>> fetchProducts() async {

    try {
      // Memanggil fungsi GET dari ApiService core
      final response = await ApiService.instance.getKatalogCocos();

      // Mengambil array map dengan key 'products' dari npoint JSON
      final List<dynamic> productData = response.data['products'];

      // Melakukan parsing ke bentuk List<ProductModel>
      return productData.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('ProductRepository Error: $e');
      throw Exception('Gagal memuat katalog produk dari server.');
    }
  }
}
 