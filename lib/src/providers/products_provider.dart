import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:login_form/src/models/product_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:login_form/src/preferences/user_prefs.dart';
import 'package:mime_type/mime_type.dart';

class ProductsProvider {
  final String _url = 'flutter-form-1db43-default-rtdb.firebaseio.com';
  final _prefs = UserPrefs();

  Future<bool> createProduct(ProductModel product) async {
    final uri = Uri.https(_url, '/products.json', {'auth': _prefs.token});
    final response = await http.post(uri, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final uri =
        Uri.https(_url, '/products/${product.id}.json', {'auth': _prefs.token});
    final response = await http.put(uri, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final uri = Uri.https(_url, '/products.json', {'auth': _prefs.token});
    final response = await http.get(uri);

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> products = [];

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<int> removeProduct(String id) async {
    final uri = Uri.https(_url, '/products/$id.json', {'auth': _prefs.token});
    final response = await http.delete(uri);

    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dhnz8almg/image/upload?upload_preset=blr6j50q');

    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Something went wrong...');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    return responseData['secure_url'];
  }
}
