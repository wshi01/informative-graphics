import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AllFourFactors extends StatefulWidget {
  const AllFourFactors({super.key});

  @override
  State<AllFourFactors> createState() => _AllFourFactorsState();
}

class _AllFourFactorsState extends State<AllFourFactors> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: Text("1"),
      ),
    );
  }
}
