import 'package:flutter/material.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:profile/profile.dart';

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key}) : super(key: key);

  @override
  VendorProfileState createState() => VendorProfileState();
}

class VendorProfileState extends State<VendorProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorDashBoard();
                })
            )
          },
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 200, 20, 0),
          child: Center(
            child: Profile(
              imageUrl: "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
              name: "Shamim Miah",
              website: "shamimmiah.com",
              designation: "Project Manager | Flutter & Blockchain Developer",
              email: "cse.shamimosmanpailot@gmail.com",
              phone_number: "01757736053",
            ),
          )
        )
    );
  }
}
