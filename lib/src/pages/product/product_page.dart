import 'package:flutter/material.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:login_form/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();

  ProductModel product = ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Producto".text.semiBold.make(),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: () {}),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
              key: formKey,
              child: Column(
                children: [
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
        onPressed: _submit,
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

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    print(product.title);
    print(product.value);
  }
}