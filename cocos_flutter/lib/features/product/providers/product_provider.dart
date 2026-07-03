import 'package:cocos_flutter/features/product/data/product_repository.dart';
import 'package:cocos_flutter/features/product/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {

  List<ProductModel> _products = [];

  bool _isLoading = false;

  String _errorMessage = '';

  List<ProductModel> get products => _products;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> loadProducts() async {

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await ProductRepository.instance.fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
 