import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_form/constants.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/providers/products_provider.dart';
import 'package:login_form/src/shared/components/custom_alert_dialog.dart';
import 'package:login_form/src/shared/components/rounded_form_field.dart';
import 'package:login_form/src/shared/components/text_field_container.dart';
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
        title: "Product".text.semiBold.make(),
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
    return RoundedFormField(
      product,
      hintText: 'Product name',
      icon: Icons.add_box,
      labelText: 'Product',
      initialValue: product.title,
      validator: (value) {
        if (value.trim().length == 0) return 'Enter product name';
        if (value.trim().length < 3) return '3 characters at least';
        return null;
      },
      onSaved: (value) => product.title = value,
    );
  }

  Widget _createPrice() {
    return RoundedFormField(
      product,
      type: TextInputType.numberWithOptions(decimal: true),
      hintText: 'Product price',
      icon: Icons.attach_money,
      labelText: 'Price',
      initialValue: '${product.value}',
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        }
        return 'Only numbers';
      },
      onSaved: (value) => product.value = double.parse(value),
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
    return TextFieldContainer(
      child: SwitchListTile(
          value: product.available,
          title: "Available".text.make(),
          activeColor: Colors.deepPurple,
          onChanged: (value) {
            setState(() {
              product.available = value;
            });
          }),
    );
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
      backgroundColor: kPrimaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _showImage() {
    Widget child;

    if (product.urlImage != null) {
      child = Image.network(
        product.urlImage,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      child = photo?.path != null
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
    return Card(
        child: child,
        elevation: 3,
        shadowColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias);
  }

  _selectImage() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource source) async {
    final selectedImage = await picker.getImage(
        source: source, imageQuality: 30, maxHeight: 1000, maxWidth: 1000);

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
