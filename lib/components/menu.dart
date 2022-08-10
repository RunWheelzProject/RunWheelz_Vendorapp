import 'package:flutter/material.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_profile_screen.dart';
import 'package:untitled/screens/vendro_staff_list.dart';
import '../colors/app_colors.dart';
import '../resources/resources.dart' as res;

class Menu extends StatelessWidget {
  Menu({Key? key}): super(key: key);

  late String _header;
  late List<String> _menuItems;

  Menu.menuData(String header, List<String> menuItems)
  {
    _header = header;
    _menuItems = menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(_header),
            ),
            for (String item in _menuItems)
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const VendorDashBoard();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Vendor Staff'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const VendorStaff();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('New Requests'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const PendingOrder(pageTitle: "New Requests", data: {"": ""});
                    })
                );
              },
            ),
          ],
        )
    );
  }
}

/*

Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("Menu"),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Vendor Staff'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Vendor Services'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('New Requests'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Request History'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        )
      ),
 */