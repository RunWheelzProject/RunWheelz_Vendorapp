import 'package:flutter/material.dart';
import 'package:untitled/components/side_menu.dart';
import 'package:untitled/screens/customer_favorite_mechnic.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';

import '../screens/customer_board.dart';
import '../screens/vendor_dashboard.dart';
import '../screens/vendor_works.dart';
import '../screens/vendro_staff_management_screen.dart';



class VendorAppBar extends StatelessWidget {
  Widget child;

  VendorAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Run Wheelz",
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return VendorDashboardProfile(
                                        isVendor: true);
                                  })
                          );
                        },
                        icon: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                        )),
                    addHorizontalSpace(20),
                    const Icon(
                      Icons.notification_add_rounded,
                      color: Colors.white,
                    ),
                    addHorizontalSpace(20),
                  ],
                )),
          ),
        ),
        drawer: Padding(
            padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
            child: SideMenu(
              menuList: [
                RWMap(
                    title: "Home",
                    icon: const Icon(Icons.home, color: Colors.deepPurple,),
                    navigateTo: const VendorDashBoard()
                ),
                RWMap(
                    title: "Vendor Works",
                    icon: const Icon(Icons.history, color: Colors.deepPurple,),
                    navigateTo: const VendorWorks()
                ),
                RWMap(
                    title: "Vendor Staff",
                    icon: const Icon(Icons.person, color: Colors.deepPurple,),
                    navigateTo: const VendorStaffManagementPage()
                )
              ],
            )

        ),
        body: child
    );
  }
}

