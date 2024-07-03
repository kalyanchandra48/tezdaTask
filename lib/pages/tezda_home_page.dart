import 'package:flutter/material.dart';
import 'package:tezda_task/constants/constants.dart';
import 'package:tezda_task/models/product.dart';
import 'package:tezda_task/pages/tezda_product_info.dart';
import 'package:tezda_task/services/products_service.dart';

class TezdaHomePage extends StatelessWidget {
  TezdaHomePage({super.key});

  final ProductsService productsService = ProductsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text('Tezda '),
        ),
        body: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) async {
                if (index == 2) {
                  // await FirebaseAuth.instance.signOut();
                  // LocalStore.deleteData('uid');
                  Navigator.pushNamed(context, '/profile');
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
            body: Center(
              child: FutureBuilder(
                  future: productsService.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator.adaptive();
                    } else {
                      return Column(
                        children: [
                          const Text(
                            'Experience The Difference.',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Find your favourite',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Expanded(
                              child:
                                  ProductGrid(products: snapshot.data ?? [])),
                        ],
                      );
                    }
                  }),
            )));
  }
}

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ProductItem(products[index]);
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(product: product);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.network(
                product.imageUrl?.isEmpty == true
                    ? noImage
                    : product.imageUrl?.first.contains('http') == true &&
                                product.imageUrl?.first.endsWith('.jpeg') ==
                                    true ||
                            product.imageUrl?.first.endsWith('.png') == true ||
                            product.imageUrl?.first.endsWith('.jpg') == true
                        ? product.imageUrl?.first ?? ''
                        : noImage,
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                product.title!.length > 20 == true
                    ? product.title?.substring(0, 20) ?? ''
                    : product.title ?? '',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '\$${product.price?.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
