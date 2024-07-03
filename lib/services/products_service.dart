import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tezda_task/constants/constants.dart';
import 'package:tezda_task/models/product.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;

  ProductsService._internal();

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(productsUrl));
    final List<dynamic> productsJson = json.decode(response.body);
    return productsJson.map((json) => Product.fromMap(json)).toList();
  }
}
