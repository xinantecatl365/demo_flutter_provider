import 'package:fl_productos_app/models/models.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      height: 350,
      decoration: _cardShape(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _BackgroundImage(url: product.picture),
          _ProducDetails(
            title: product.id!,
            details: product.name,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _PriceTag(price: product.price),
          ),
          if (!product.available)
            const Positioned(
              top: 0,
              left: 0,
              child: _Available(),
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          )
        ],
      );
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    super.key,
    required this.price,
  });

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$price',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _Available extends StatelessWidget {
  const _Available({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({super.key, this.url});
  final placeholderUrl = 'https://via.placeholder.com/400x360/f6f6f6';
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null
            ? Image.asset('assets/no-image.png', fit: BoxFit.cover)
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _ProducDetails extends StatelessWidget {
  const _ProducDetails({super.key, required this.title, required this.details});
  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _productDetailDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              details,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _productDetailDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}
