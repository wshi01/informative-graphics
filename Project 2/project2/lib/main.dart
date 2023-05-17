import 'package:flutter/material.dart';
import 'package:project2/selections/1.dart';
import 'package:project2/selections/2.dart';
import 'package:project2/selections/3.dart';
import 'package:project2/selections/4.dart';
import 'package:project2/selections/5.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SWOT',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'SWOT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllFourFactors()),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 214, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("All Four Factors"),
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Opportunity()),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 214, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Opportunity Analysis Data"),
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Strength()),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 214, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Strength Analysis Data"),
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Threat()),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 214, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Threat Analysis Data"),
              ),
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Weakness()),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 214, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Weakness Analysis Data"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
