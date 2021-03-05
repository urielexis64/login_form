import 'package:flutter/material.dart';

import 'package:login_form/src/models/product_model.dart';

class RemovableCard extends StatelessWidget {
  final ProductModel product;
  final Function onRemove;
  final Function onTap;

  RemovableCard({
    this.product,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            (product.urlImage == null)
                ? Hero(
                    tag: 'no-image',
                    child: Image.asset('assets/images/no-image.png'))
                : Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/jar-loading.gif'),
                      image: NetworkImage(product.urlImage),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            Expanded(
              child: Divider(),
            ),
            Text(
              product.title,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 6,
            )
          ]),
        ),
        Positioned(
          right: -14,
          top: -14,
          child: IconButton(
            padding: EdgeInsetsDirectional.zero,
            iconSize: 24,
            color: Colors.redAccent,
            icon: Icon(
              Icons.remove_circle,
            ),
            onPressed: onRemove,
            tooltip: 'Remove ${product.title}',
          ),
        )
      ]),
      onTap: onTap,
    );
  }
}
