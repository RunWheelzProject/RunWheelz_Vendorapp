import 'package:flutter/material.dart';
import 'package:untitled/screens/customer_favorite_mechnic.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';

import '../screens/customer_board.dart';



class CustomerAppBar extends StatelessWidget {
  Widget child;

  CustomerAppBar({super.key, required this.child});

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
                                        isCustomer: true);
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
            child: Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Home',
                        style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CustomerDashBoard(isCustomer: true);
                            })
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Request History',
                        style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const CustomerRequestHistory();
                            })
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('My Mechanics',
                        style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CustomerFavoriteMechanic();
                            })
                        );
                      },
                    ),
                  ],
                )
            )),
        body: child
    );
  }
}