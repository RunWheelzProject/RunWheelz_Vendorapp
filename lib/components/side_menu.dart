import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendro_staff_management_screen.dart';
import '../colors/app_colors.dart';
import '../manager/login_manager.dart';
import '../resources/resources.dart' as res;
import '../screens/vendor_works.dart';


class RWMap {
  String title;
  Icon icon;
  dynamic navigateTo;
  RWMap({required this.title, required this.icon, required this.navigateTo});
}


class SideMenu extends StatelessWidget {

  List<RWMap> menuList;
  SideMenu({Key? key, required this.menuList}): super(key: key);


  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context);
    return Drawer(
        child: ListView(
          children: [
            for (RWMap menu in menuList)
            ListTile(
              hoverColor: Colors.black12,
              horizontalTitleGap: 5,
              shape: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)
              ),
              title: Text(menu.title, style: const TextStyle(color: Colors.red, fontSize: 16),),
              leading: menu.icon,
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return menu.navigateTo;
                    })
                );
              },
            ),
          ],
        )
    );
  }
}