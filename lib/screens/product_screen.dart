import 'package:fl_productos_app/providers/product_form_provider.dart';
import 'package:fl_productos_app/services/services.dart';
import 'package:fl_productos_app/ui/custom_input_decorations.dart';
import 'package:fl_productos_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(
        product: productService.selectedProduct,
      ),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productService,
  });

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ImageOverlay(
              productService: productService,
            ),
            const _ProductForm(),
            const SizedBox(height: 75),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;
                final String? imageUrl = await productService.uploadImage();
                if (imageUrl != null) productForm.product.picture = imageUrl;

                await productService.saveOrCreateProduct(productForm.product);
              },
        child: productService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productFormP = Provider.of<ProductFormProvider>(context);
    final product = productFormP.product;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Form(
        key: productFormP.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'El nombre es obligatorio'
                      : null;
                },
                decoration: CustomInputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                ],
                initialValue: '${product.price}',
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: CustomInputDecorations.authInputDecoration(
                  hintText: '\$000.00',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(height: 25),
              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productFormP.updateAvailability,
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageOverlay extends StatelessWidget {
  const _ImageOverlay({super.key, required this.productService});

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductImage(url: productService.selectedProduct.picture),
        Positioned(
          top: 60,
          left: 20,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () async {
              final picker = ImagePicker();
              XFile? pickedFile = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 100,
              );

              if (pickedFile == null) {
                print('no selecciono nada');
                return;
              }

              productService.updateSelectedProductImage(pickedFile.path);
            },
          ),
        ),
      ],
    );
  }
}
