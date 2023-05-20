import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../ChartScreen3.dart';

class Opportunity extends StatefulWidget {
  const Opportunity({super.key});

  @override
  State<Opportunity> createState() => _OpportunityState();
}

class _OpportunityState extends State<Opportunity> {
  List<String> lines = [];
  Map<String, String> newData = {};
  int counter = 3;

  @override
  void initState() {
    super.initState();
    newData = {
      'CATEGORY': 'Opportunity',
      'FACTOR TYPES': 'POSITIVE',
      'Sl #': '',
      'PARAM NAME': '',
      'EST. VALUE IN CURRENCY': '',
      'MIN PROB %': '',
      'REALISTIC PROB %': '',
      'MAX PROB %': '',
    };
  }

  void _addNew() {
    setState(() {
      counter = counter + 1;
      newData['Sl #'] = (counter).toString();
    });
  }

  void _addNewLine() {
    _writeDataToCSV(newData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChartScreen3(),
      ),
    );
  }

  Future<void> _writeDataToCSV(Map<String, String> newData) async {
    _addNew();
    String csvData = _dataToCsvRow(newData);
    await writeCSVToFile(csvData);
  }

  String _dataToCsvRow(Map<String, String> data) {
    double estProbAdjusted = double.parse(data['EST. VALUE IN CURRENCY']!);
    double minProb = double.parse(data['MIN PROB %']!);
    double realisticProb = double.parse(data['REALISTIC PROB %']!);
    double maxProb = double.parse(data['MAX PROB %']!);

    // calculations
    double one = (minProb + realisticProb + maxProb) / 3;
    double two = (minProb + (4 * realisticProb) + maxProb) / 6;
    double three = estProbAdjusted * (minProb / 100);
    double four = estProbAdjusted * (maxProb / 100);
    double five = (three + four) / 2;
    double six = estProbAdjusted * (realisticProb / 100);
    double seven = estProbAdjusted * (one / 100);
    double eight = estProbAdjusted * (two / 100);
    return '${data['CATEGORY']},${data['FACTOR TYPES']},${data['Sl #']},${data['PARAM NAME']},${data['EST. VALUE IN CURRENCY']},${data['MIN PROB %']},${data['REALISTIC PROB %']}, ${data['MAX PROB %']},${one.toStringAsFixed(1)},${two.toStringAsFixed(1)},${three.toStringAsFixed(1)},${four.toStringAsFixed(1)},${five.toStringAsFixed(1)},${six.toStringAsFixed(1)},${seven.toStringAsFixed(1)},${eight.toStringAsFixed(1)}\n';
  }

  Future<void> writeCSVToFile(String csvData) async {
    Directory? directoryPath = await getExternalStorageDirectory();
    String csvFilePath = '${directoryPath?.path}/Opportunity Analysis Data.csv';

    File file = File(csvFilePath);
    await file.writeAsString(csvData, mode: FileMode.append);
    print('CSV file written successfully!');
    // await updateCSVToJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Parameter name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    newData['PARAM NAME'] = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Estimated value in currency',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    newData['EST. VALUE IN CURRENCY'] = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Minimum probability',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    newData['MIN PROB %'] = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Realistic probability',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    newData['REALISTIC PROB %'] = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Maximum probability',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    newData['MAX PROB %'] = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
                width: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _addNewLine();
                    },
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 204, 255, 204),
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        border: Border.all(
                          color: Colors.black,
                          width: 1, // Adjust the border width as needed
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChartScreen3(),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 204),
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        border: Border.all(
                          color: Colors.black,
                          width: 1, // Adjust the border width as needed
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('View', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
