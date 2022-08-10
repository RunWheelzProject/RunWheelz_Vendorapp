import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../components/button.dart';

class PendingOrderCard extends StatelessWidget {
  const PendingOrderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: const <Widget>[
                SizedBox(width: 18),
                Icon(Icons.person, color: Colors.purple,),
                SizedBox(width: 15),
                Text("Request ID: ", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                Text("787865", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: const <Widget>[
                SizedBox(width: 18),
                Icon(Icons.tire_repair, color: Colors.purple),
                SizedBox(width: 15),
                Text("Service: ", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                Text("Puncture", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
              ],
            ),
            //const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('VIEW REQUEST', style: TextStyle(color: Colors.purple)),
                  onPressed: () {/* ... */},
                )
              ],
            ),
          ],
        ),
      ));
  }
}
