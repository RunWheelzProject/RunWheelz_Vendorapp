import 'package:flutter/material.dart';



class ItemRow extends StatelessWidget {
  late String _key;
  late String? _value;
  ItemRow(String k, String? v, {Key? key}): super(key: key) {
    _key = k;
    _value = v;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.white);
    return Row(
      children: [
        Text(_key, style: style),
        const Text(": ", style: style),
        Text(_value!, style: style),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}



