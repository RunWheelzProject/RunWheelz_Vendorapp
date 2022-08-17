import 'package:flutter/material.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../resources/resources.dart' as res;

typedef CallBack = void Function();

class VendorDashBoard extends StatefulWidget {
  const VendorDashBoard({Key? key}) : super(key: key);

  @override
  VendorDashBoardState createState() => VendorDashBoardState();
}

class VendorDashBoardState extends State<VendorDashBoard> {
  TextEditingController phoneNumberController = TextEditingController();
  final bool _validate = false;
  final String _error = "";

  void goToRequests() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return const VendorDataManagementPage(pageTitle: "New Requests");
        })
    );
  }

  void goToInProgress() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return const VendorDataManagementPage(pageTitle: "In Progress");
        })
    );
  }
  void goToPendingRequests() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return const VendorDataManagementPage(pageTitle: "Pending Requests");
        })
    );
  }

  void goToRaisedRequests() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return const VendorDataManagementPage(pageTitle: "Raised Requests");
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
                          MaterialPageRoute(builder: (BuildContext context) {
                            return VendorProfile();
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
            child: Menu.menuData("menu", res.menuItems)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  padding: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 10,
                            blurRadius: 30),
                      ]),
                  child: Column(children: <Widget>[
                    Text(
                      "Vendor Dashboard",
                      style: textTheme.headline4,
                    ),
                    addVerticalSpace(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashBoardBox(
                            callBack: goToRequests,
                            icon: const Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "New Requests",
                            count: "12"
                        ),
                        DashBoardBox(
                            callBack: goToInProgress,
                            icon: const Icon(
                              Icons.file_download,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "In Progress",
                            count: "23"),
                      ],
                    ),
                    addVerticalSpace(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashBoardBox(
                            callBack: goToPendingRequests,
                            icon: const Icon(
                              Icons.pending_actions_rounded,
                              color: Colors.purple,
                              size: 34
                            ),
                            title: "Pending Requests",
                            count: "23"),
                        DashBoardBox(
                            callBack: goToRaisedRequests,
                            icon: const Icon(
                              Icons.new_label_outlined,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "Raise Request",
                            count: "34"
                        ),
                      ],
                    )
                  ])
              )
            )
        )
    );
  }
}
