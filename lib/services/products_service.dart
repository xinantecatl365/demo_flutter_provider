import 'dart:convert';
import 'dart:io';

import 'package:fl_productos_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final _baseUrl = 'crud-productos-app-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  File? newPicture;

  final storage = const FlutterSecureStorage();

  late Product selectedProduct;

  ProductService() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.get(url);
    final Map<String, dynamic> productMap = json.decode(resp.body);
    productMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPicture = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPicture == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dgmpypnez/image/upload?upload_preset=bw2p8dml');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    newPicture = null;

    final decodedData = jsonDecode(resp.body);
    return decodedData['secure_url'];
  }
}
