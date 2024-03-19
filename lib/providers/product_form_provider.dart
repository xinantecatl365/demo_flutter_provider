// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:fl_productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  ProductFormProvider({required this.product});

  GlobalKey<FormState> formKey = GlobalKey();
  Product product;

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  void updateAvailability(bool value) {
    product.available = value;
    notifyListeners();
  }
}
