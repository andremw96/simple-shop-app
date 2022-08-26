import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("hello friend"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
