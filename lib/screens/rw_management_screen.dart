import 'package:flutter/material.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import '../components/menu.dart';
import '../screens/rw_staff_management_screen.dart';
import '../screens/rw_vendor_management_screen.dart';
import '../components/logo.dart';
import '../utils/add_space.dart';
import '../resources/resources.dart' as res;

class RunWheelManagementPage extends StatefulWidget {

  const RunWheelManagementPage({Key? key}) : super(key: key);

  @override
  State<RunWheelManagementPage> createState() => _RunWheelManagementPageState();
}

class _RunWheelManagementPageState extends State<RunWheelManagementPage> {

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
                    const Text("Management",
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return Profile();
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
            padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
            child: menu()
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(
                color: Colors.blue,
                width: 3
              ))
            ),
            width: MediaQuery.of(context).size.width,
            child: Logo()
          ),
          const SizedBox(height: 20,),
          const Text("Activities",
          textAlign: TextAlign.end,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 70,),
          InkWell(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blue))
              ),
              child: const Text("Vendor Management", style: TextStyle(fontSize: 18),),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const VendorManagementPage();
                  })
              );
            },
          ),
          const SizedBox(height: 40,),
          InkWell(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blue))
                ),
                child: const Text("Staff Management", style: TextStyle(fontSize: 18),),
              ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const StaffManagementPage();
                  })
              );
            },
          ),
          const SizedBox(height: 70,),
          const Text("Reports",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              )
          ),
          const SizedBox(height: 70,),
          InkWell(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.blue))
              ),
              child: const Text("Vendor Management", style: TextStyle(fontSize: 18),),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const VendorManagementPage();
                  })
              );
            },
          ),
          const SizedBox(height: 40,),
          InkWell(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.blue))
              ),
              child: const Text("Staff Management", style: TextStyle(fontSize: 18),),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const StaffManagementPage();
                  })
              );
            },
          )
        ]
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget menu() {
    return Drawer(
        width: 220,
        child: ListView(
            children: [
              DrawerHeader(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blue, width: 2))
                  ),
                  child: const Text("Admin, Venkat Chary Padala"),
                )
              ),
              ListTile(
                title: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.deepPurple, width: 2))
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.garage_outlined, color: Colors.deepPurple,),
                        SizedBox(width: 20,),
                        Text("Vendor")
                      ],
                    )
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const VendorManagementPage();
                      })
                  );
                },
              ),
              ListTile(
                title: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.deepPurple, width: 3))
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.deepPurple,),
                        SizedBox(width: 20,),
                        Text("Staff")
                      ],
                    )
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const StaffManagementPage();
                      })
                  );
                },
              )
            ])
    );
  }
}
