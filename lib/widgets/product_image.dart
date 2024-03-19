import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: 400,
      decoration: _decorationImageContainer(),
      child: Opacity(
        opacity: 0.8,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          child: GetImage(url: url),
        ),
      ),
    );
  }

  BoxDecoration _decorationImageContainer() => const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
          )
        ],
      );
}

class GetImage extends StatelessWidget {
  const GetImage({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Image.asset('assets/no-image.png', fit: BoxFit.cover);
    }

    if (url!.startsWith('http')) {
      return FadeInImage(
        image: NetworkImage(url!),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }
    return Image.file(File(url!), fit: BoxFit.cover);
  }
}
