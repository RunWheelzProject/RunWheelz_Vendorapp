import 'package:flutter/material.dart';

import '../components/logo.dart';


class StaffManagementPage extends StatefulWidget {

  const StaffManagementPage({Key? key}) : super(key: key);

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Management"),
        ),
        drawer: const Drawer(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(
                          color: Colors.blue,
                          width: 3
                      ))
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: const Logo()
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
                onTap: () {},
              ),
              const SizedBox(height: 40,),
              InkWell(
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.blue))
                  ),
                  child: const Text("Staff Management", style: TextStyle(fontSize: 18),),
                ),
                onTap: () {},
              )
            ]
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
