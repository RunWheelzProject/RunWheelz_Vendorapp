import 'package:flutter/material.dart';
import 'package:untitled/utils/add_space.dart';


typedef CallBack = void Function();

class DashBoardBox extends StatefulWidget {
  final CallBack callBack;
  final Icon icon;
  final String title;
  final String? count;
  const DashBoardBox({Key? key, required this.callBack, required this.icon, required this.title, this.count}) : super(key: key);

  @override
  DashBoardBoxState createState() => DashBoardBoxState();
}

class DashBoardBoxState extends State<DashBoardBox> {


  @override
  Widget build(BuildContext context) {
    String count = widget.count as String;
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
        onTap: widget.callBack,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[100] as Color),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 7,
                  blurRadius: 20,
                )
              ]),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.icon,
                addVerticalSpace(10),
                Text(
                  widget.title,
                  style: textTheme.subtitle1,
                ),
                addVerticalSpace(10),
                if (widget.count != null)
                  Text(count, style: const TextStyle(fontSize: 21, color: Colors.red)),
              ]),
        )
    );
  }
}
