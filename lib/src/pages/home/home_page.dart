import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_form/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/welcome.svg',
                width: size.width * .8,
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                '${bloc.email}',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.edit),
              onTap: () {},
              tileColor: Colors.grey[100],
              shape: StadiumBorder(),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('${bloc.password}',
                  style: TextStyle(fontWeight: FontWeight.w400)),
              trailing: Icon(Icons.edit),
              onTap: () {},
              tileColor: Colors.grey[100],
              shape: StadiumBorder(),
            )
          ],
        ),
      ),
      floatingActionButton: _createButton(context),
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
