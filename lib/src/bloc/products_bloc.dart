import 'dart:io';

import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  final _productsController = BehaviorSubject<List<ProductModel>>();
  final _loadingController = BehaviorSubject<bool>();

  final _productsProvider = ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File file) async {
    _loadingController.sink.add(true);
    final imageUrl = await _productsProvider.uploadImage(file);
    _loadingController.sink.add(false);

    return imageUrl;
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  Future<void> removeProduct(String id) async {
    await _productsProvider.removeProduct(id);
  }

  dispose() {
    _productsController.close();
    _loadingController.close();
  }
}
