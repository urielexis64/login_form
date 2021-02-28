import 'package:flutter/material.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/pages/home/components/removable_card.dart';
import 'package:login_form/src/providers/products_provider.dart';
import 'package:login_form/src/shared/components/custom_alert_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: GridView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) =>
                    _createItem(context, products[index], products, index)),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(
      BuildContext context, ProductModel product, List products, int index) {
    return RemovableCard(
        product: product,
        onRemove: () {
          _removeItem(product, products, index);
        },
        onTap: () =>
            Navigator.pushNamed(context, 'product', arguments: product));
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'product').then((value) {
            setState(() {});
          });
        });
  }

  Future<void> _removeItem(
      ProductModel product, List products, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Remove item',
          onConfirmed: () {
            productsProvider
                .removeProduct(product.id)
                .then((value) => setState(() {
                      products.removeAt(index);
                      Navigator.pop(context);
                    }));
          },
          contentWidgets: [
            Text("Are you sure you want to remove '${product.title}'?"),
          ],
        );
      },
    );
  }
}
