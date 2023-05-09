import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';

class Threat extends StatefulWidget {
  const Threat({super.key});

  @override
  State<Threat> createState() => _ThreatState();
}

class _ThreatState extends State<Threat> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: Text("4"),
      ),
    );
  }
}
