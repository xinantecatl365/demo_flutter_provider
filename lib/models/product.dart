// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  Product({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    this.id,
  });
  bool available;
  String name;
  String? picture;
  double price;
  String? id;

  factory Product.fromJson(String str) => Product.fromJson(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json['available'],
        name: json['name'],
        picture: json['picture'],
        price: json['price'] as double,
      );

  Map<String, dynamic> toMap() => {
        'available': available,
        'name': name,
        'picture': picture,
        'price': price,
      };

  Product copyWith({
    bool? newAvailable,
    String? newName,
    String? newPicture,
    double? newPrice,
    String? newId,
  }) =>
      Product(
        available: newAvailable ?? available,
        name: newName ?? name,
        picture: newPicture ?? picture,
        price: newPrice ?? price,
        id: newId ?? id,
      );
}
