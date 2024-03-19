import 'package:fl_productos_app/models/models.dart';
import 'package:fl_productos_app/screens/loading_screen.dart';
import 'package:fl_productos_app/services/services.dart';
import 'package:fl_productos_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductService>(context);
    final authService = Provider.of<AuthService>(context);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.logout)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct =
                productsService.products[index].copyWith();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productsService.products[index]),
        ),
        itemCount: productsService.products.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct = Product(
            available: false,
            name: '',
            price: 0.0,
          );
          Navigator.of(context).pushNamed('product');
        },
      ),
    );
  }
}
