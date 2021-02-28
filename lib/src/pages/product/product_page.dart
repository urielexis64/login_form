import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/providers/products_provider.dart';
import 'package:login_form/src/shared/components/custom_alert_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:login_form/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productsProvider = ProductsProvider();

  ProductModel product = ProductModel();
  final picker = ImagePicker();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    final ProductModel productArg = ModalRoute.of(context).settings.arguments;
    if (productArg != null) {
      product = productArg;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: "Producto".text.semiBold.make(),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _selectImage),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  GestureDetector(onTap: _selectImage, child: _showImage()),
                  20.heightBox,
                  _createName(),
                  20.heightBox,
                  _createPrice(),
                  _createAvailable(),
                  50.heightBox,
                  _createSubmitButton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: product.title,
      focusNode: FocusNode(canRequestFocus: false),
      decoration: InputDecoration(
        labelText: 'Product',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: Icon(
          Icons.photo,
        ),
      ),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.trim().length == 0) return 'Enter product name';
        if (value.trim().length < 3) return '3 characters at least';
        return null;
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      enableInteractiveSelection: false,
      initialValue: '${product.value}',
      focusNode: FocusNode(canRequestFocus: false),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: Icon(
          Icons.attach_money,
        ),
      ),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        }
        return 'Only numbers';
      },
    );
  }

  Widget _createSubmitButton() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            onSurface: Colors.grey,
            shape: StadiumBorder()),
        label: 'Save'.text.make(),
        onPressed: _saving ? null : _submit,
        icon: Icon(Icons.save));
  }

  Widget _createAvailable() {
    return SwitchListTile(
        value: product.available,
        title: "Available".text.make(),
        activeColor: Colors.deepPurple,
        onChanged: (value) {
          setState(() {
            product.available = value;
          });
        });
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    _loading();

    if (photo != null) {
      String urlImage = await productsProvider.uploadImage(photo);
      product.urlImage = urlImage;
    }

    String message;

    if (product.id == null) {
      productsProvider.createProduct(product);
      message = 'Product created successfully';
    } else {
      productsProvider.updateProduct(product);
      message = 'Product updated successfully';
    }
    Navigator.pop(context);
    Navigator.pop(context);
    showSnackbar(message);
  }

  void showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _showImage() {
    if (product.urlImage != null) {
      return Image.network(
        product.urlImage,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return photo?.path != null
          ? Image.file(
              photo,
              fit: BoxFit.cover,
              height: 250,
            )
          : Image.asset(
              'assets/images/no-image.png',
              height: 250,
              fit: BoxFit.cover,
            );
    }
  }

  _selectImage() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource source) async {
    final selectedImage = await picker.getImage(source: source);

    if (selectedImage != null) {
      photo = File(selectedImage.path);
      product.urlImage = null;
    }

    setState(() {});
  }

  Future<void> _loading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Loading...',
          actions: false,
          contentWidgets: [
            Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Uploading product...")
              ],
            )
          ],
        );
      },
    );
  }
}
