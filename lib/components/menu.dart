import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendro_staff_management_screen.dart';
import '../colors/app_colors.dart';
import '../manager/login_manager.dart';
import '../resources/resources.dart' as res;

class Menu extends StatelessWidget {
  Menu({Key? key}): super(key: key);

  late String _header;
  late List<String> _menuItems;
  late List<Icon> _icons;

  Menu.menuData(String header, List<String> menuItems)
  {
    _header = header;
    _menuItems = menuItems;
  }
  Menu.menuNamesandIcons(String header, List<String> menuItems, List<Icon> icons)
  {
    _header = header;
    _menuItems = menuItems;
    _icons = icons;
  }

  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context);
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(_header),
            ),
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
                logInManager.setCurrentURLs("mechanicRegistration");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const VendorStaffManagementPage();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('New Requests'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const VendorDataManagementPage(pageTitle: "New Requests");
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Raise Request'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const VendorDataManagementPage(pageTitle: "New Requests");
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