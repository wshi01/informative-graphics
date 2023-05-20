import 'package:flutter/cupertino.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Directory? appDocumentsDirectory =
                        await getExternalStorageDirectory();
                    String? appDocumentsPath = appDocumentsDirectory?.path;

                    String csvAssetPath = 'data/Strength Analysis Data.csv';
                    String csvPath =
                        '$appDocumentsPath/Strength Analysis Data.csv';

                    File csvFile = File(csvPath);
                    if (!csvFile.existsSync()) {
                      ByteData csvByteData =
                          await rootBundle.load(csvAssetPath);
                      List<int> csvBytes = csvByteData.buffer.asUint8List(
                          csvByteData.offsetInBytes, csvByteData.lengthInBytes);
                      await csvFile.writeAsBytes(csvBytes);
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Strength()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 204, 255, 204),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "S",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "trength",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    Directory? appDocumentsDirectory =
                        await getExternalStorageDirectory();
                    String? appDocumentsPath = appDocumentsDirectory?.path;

                    String csvAssetPath = 'data/Weakness Analysis Data.csv';
                    String csvPath =
                        '$appDocumentsPath/Weakness Analysis Data.csv';

                    File csvFile = File(csvPath);
                    if (!csvFile.existsSync()) {
                      ByteData csvByteData =
                          await rootBundle.load(csvAssetPath);
                      List<int> csvBytes = csvByteData.buffer.asUint8List(
                          csvByteData.offsetInBytes, csvByteData.lengthInBytes);
                      await csvFile.writeAsBytes(csvBytes);
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Weakness()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 204),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "W",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "eakness",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
              width: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Directory? appDocumentsDirectory =
                        await getExternalStorageDirectory();
                    String? appDocumentsPath = appDocumentsDirectory?.path;

                    String csvAssetPath = 'data/Opportunity Analysis Data.csv';
                    String csvPath =
                        '$appDocumentsPath/Opportunity Analysis Data.csv';

                    File csvFile = File(csvPath);
                    if (!csvFile.existsSync()) {
                      ByteData csvByteData =
                          await rootBundle.load(csvAssetPath);
                      List<int> csvBytes = csvByteData.buffer.asUint8List(
                          csvByteData.offsetInBytes, csvByteData.lengthInBytes);
                      await csvFile.writeAsBytes(csvBytes);
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Opportunity()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 204, 230, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "O",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "pportunity",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    Directory? appDocumentsDirectory =
                        await getExternalStorageDirectory();
                    String? appDocumentsPath = appDocumentsDirectory?.path;

                    String csvAssetPath = 'data/Threat Analysis Data.csv';
                    String csvPath =
                        '$appDocumentsPath/Threat Analysis Data.csv';

                    File csvFile = File(csvPath);
                    if (!csvFile.existsSync()) {
                      ByteData csvByteData =
                          await rootBundle.load(csvAssetPath);
                      List<int> csvBytes = csvByteData.buffer.asUint8List(
                          csvByteData.offsetInBytes, csvByteData.lengthInBytes);
                      await csvFile.writeAsBytes(csvBytes);
                    }

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Threat()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 204, 204),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "T",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "hreat",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
