import 'package:flutter/material.dart';
import 'package:tezda_task/constants/constants.dart';
import 'package:tezda_task/models/product.dart';

ValueNotifier<bool> isFavorite = ValueNotifier<bool>(false);

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            // Handle back button press
          },
        ),
        actions: [
          ValueListenableBuilder(
              valueListenable: isFavorite,
              builder: (context, favorite, snapshot) {
                return IconButton(
                  icon: Icon(Icons.favorite,
                      color: favorite ? Colors.orange : Colors.black),
                  onPressed: () {
                    isFavorite.value = !isFavorite.value;
                    // Handle favorite button press
                  },
                );
              }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      product.imageUrl?.isEmpty == true
                          ? noImage
                          : product.imageUrl?.first.contains('http') == true &&
                                      product.imageUrl?.first
                                              .endsWith('.jpeg') ==
                                          true ||
                                  product.imageUrl?.first.endsWith('.png') ==
                                      true ||
                                  product.imageUrl?.first.endsWith('.jpg') ==
                                      true
                              ? product.imageUrl?.first ?? ''
                              : noImage,
                    )),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  SizedBox(width: 4.0),
                  Text(
                    '4.5',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    '54 reviews',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {
                  // Handle share button press
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            product.title ?? '',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            product.description ?? '',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price?.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle add to cart button press
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
