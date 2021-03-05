import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/pages/home/components/removable_card.dart';
import 'package:login_form/src/preferences/user_prefs.dart';
import 'package:login_form/src/shared/components/custom_alert_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                final prefs = UserPrefs();
                prefs.token = '';
                Navigator.pushReplacementNamed(context, 'login');
              })
        ],
      ),
      body: RefreshIndicator(
          color: Colors.deepPurple,
          onRefresh: () async {
            productsBloc.loadProducts();
          },
          child: _createListView(productsBloc)),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createListView(ProductsBloc bloc) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.productsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data;
          if (products.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/empty.svg',
                        width: size.width * .8,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'There\'s no products',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20),
                      ),
                    ],
                  )),
            );
          }
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
                itemBuilder: (context, index) => _createItem(
                    context, bloc, products[index], products, index)),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductsBloc bloc,
      ProductModel product, List products, int index) {
    return RemovableCard(
        product: product,
        onRemove: () {
          _removeItem(product, bloc, products, index);
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
      ProductModel product, ProductsBloc bloc, List products, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Remove item',
          onConfirmed: () {
            bloc.removeProduct(product.id).then((value) => setState(() {
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
