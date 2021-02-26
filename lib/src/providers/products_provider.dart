import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_form/src/models/product_model.dart';

class ProductsProvider {
  final String _url = 'flutter-form-1db43-default-rtdb.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final uri = Uri.https(_url, '/products.json');
    final response = await http.post(uri, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final uri = Uri.https(_url, '/products/${product.id}.json');
    final response = await http.put(uri, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final uri = Uri.https(_url, '/products.json');
    final response = await http.get(uri);

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> products = [];

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<int> removeProduct(String id) async {
    final uri = Uri.https(_url, '/products/$id.json');
    final response = await http.delete(uri);

    print(json.decode(response.body));

    return 1;
  }
}
