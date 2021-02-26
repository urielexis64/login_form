import 'package:flutter/material.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/providers/products_provider.dart';

class HomePage extends StatelessWidget {
  final productsProvider = ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'))
        ],
      ),
      body: _createListView(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createListView() {
    return FutureBuilder(
      future: productsProvider.loadProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data;
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _createItem(context, products[index]));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.redAccent),
      onDismissed: (direction) {
        productsProvider.removeProduct(product.id);
      },
      child: ListTile(
        title: Text(product.title),
        subtitle: Text('${product.id}'),
        onTap: () {
          Navigator.pushNamed(context, 'product', arguments: product);
        },
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'product');
        });
  }
}
