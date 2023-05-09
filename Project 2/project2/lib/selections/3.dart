import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';

class Strength extends StatefulWidget {
  const Strength({super.key});

  @override
  State<Strength> createState() => _StrengthState();
}

class _StrengthState extends State<Strength> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: Text("3"),
      ),
    );
  }
}
