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

import '../ChartScreen.dart';

class Weakness extends StatefulWidget {
  const Weakness({Key? key}) : super(key: key);

  @override
  State<Weakness> createState() => _WeaknessState();
}

class _WeaknessState extends State<Weakness> {
  List<Map<String, dynamic>>? _data;
  bool _isInitialized = false;
  Key _chartKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    copyCSVFile().then((_) {
      convertCSVToJson();
    });
  }

  Future<void> copyCSVFile() async {
    String directoryPath = (await getApplicationDocumentsDirectory()).path;
    String folderPath = '$directoryPath/com.example.project2';
    String csvFilePath = '$folderPath/Weakness Analysis Data.csv';
    Directory(folderPath).create(recursive: true);
    File file = File(csvFilePath);
    if (!file.existsSync()) {
      String csvAssetPath = 'data/Weakness Analysis Data.csv';
      ByteData csvAssetData = await rootBundle.load(csvAssetPath);
      List<int> bytes = csvAssetData.buffer.asUint8List();
      await file.writeAsBytes(bytes, mode: FileMode.append);
      print('CSV file copied successfully!');
    } else {
      print("already there!!");
    }

    // Read the CSV file contents and write them to the new file
    String csvData =
        await rootBundle.loadString('data/Weakness Analysis Data.csv');
    await file.writeAsString(csvData);
    print('CSV file contents copied successfully!');
  }

  Future<void> _showAddNewLineDialog() async {
    Map<String, String> newData = {
      'CATEGORY': 'Weakness',
      'FACTOR TYPES': 'NEGATIVE',
      'Sl #': ((_data?.length ?? 0) + 1).toString(),
      'PARAM NAME': '',
      'EST. VALUE IN CURRENCY': '',
      'MIN PROB %': '',
      'REALISTIC PROB %': '',
      'MAX PROB %': '',
    };

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Line'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'PARAM NAME'),
                onChanged: (value) {
                  newData['PARAM NAME'] = "Test";
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'EST. VALUE IN CURRENCY'),
                onChanged: (value) {
                  newData['EST. VALUE IN CURRENCY'] = "-90000";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'MIN PROB %'),
                onChanged: (value) {
                  newData['MIN PROB %'] = "40";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'REALISTIC PROB %'),
                onChanged: (value) {
                  newData['REALISTIC PROB %'] = "60";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'MAX PROB %'),
                onChanged: (value) {
                  newData['MAX PROB %'] = "70";
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewLine(newData);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewLine(Map<String, String> newData) {
    _writeDataToCSV(newData).then((_) {
      debugPrint('Long String: $_data', wrapWidth: 1000);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChartScreen(),
        ),
      );
    });
  }

  Future<void> _writeDataToCSV(Map<String, String> newData) async {
    String csvData = _dataToCsvRow(newData);
    await writeCSVToFile(csvData, append: true);
    // Update the graph with the latest data
  }

  String _dataToCsvRow(Map<String, String> data) {
    return '${data['CATEGORY']},${data['FACTOR TYPES']},${data['Sl #']},test name,-90000.0,60.0,80.0,90.0,73.3333,76.6667,-40000,-72000,-56000,-64000,-58667,-61333\n';
    // return '"${data['CATEGORY']}","${data['FACTOR TYPES']}",${data['Sl #']},"${data['PARAM NAME']}","${data['EST. VALUE IN CURRENCY']}","${data['MIN PROB %']}","${data['REALISTIC PROB %']}","${data['MAX PROB %']}",73.3333,76.6667,-40000,-72000,-56000,-64000,-58667,-61333\n';
  }

  Future<String> loadCSVFromAssets() async {
    String csvAssetPath =
        'data/Weakness Analysis Data.csv'; // Path to your CSV file in assets folder
    String csvData = await rootBundle.loadString(csvAssetPath);
    return csvData;
  }

  Future<void> writeCSVToFile(String csvData, {bool append = false}) async {
    Directory? directoryPath = await getExternalStorageDirectory();
    String csvFilePath = '${directoryPath?.path}/Weakness Analysis Data.csv';

    File file = File(csvFilePath);
    if (append) {
      await file.writeAsString(csvData, mode: FileMode.append);
    } else {
      await file.writeAsString(csvData, mode: FileMode.write);
    }
    print('CSV file written successfully!');
    await updateCSVToJson(); // Update the graph with the latest data
  }

  Future<void> convertCSVToJson() async {
    String csvData =
        await rootBundle.loadString('data/Weakness Analysis Data.csv');
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);
    List<Map<String, dynamic>> rowsAsListOfMaps = [];
    List<String> headers =
        rowsAsListOfValues[0].map((e) => e.toString()).toList();
    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      List<dynamic> row = rowsAsListOfValues[i];
      Map<String, dynamic> rowAsMap = {};
      for (var j = 0; j < headers.length; j++) {
        rowAsMap[headers[j]] = row[j].toString();
      }
      rowsAsListOfMaps.add(rowAsMap);
    }

    setState(() {
      _data = rowsAsListOfMaps;
      debugPrint('Long String: $_data', wrapWidth: 1000);
    });
  }

  Future<void> updateCSVToJson() async {
    String csvFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/com.example.project2/Weakness Analysis Data.csv';
    String csvData = await File(csvFilePath).readAsString();
    List<List<dynamic>> rowsAsListOfValues =
        CsvToListConverter().convert(csvData);
    List<Map<String, dynamic>> rowsAsListOfMaps = [];
    List<String> headers =
        rowsAsListOfValues[0].map((e) => e.toString()).toList();

    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      List<dynamic> row = rowsAsListOfValues[i];
      Map<String, dynamic> rowAsMap = {};

      for (var j = 0; j < headers.length; j++) {
        rowAsMap[headers[j]] = row[j].toString();
      }
      rowsAsListOfMaps.add(rowAsMap);
    }

    setState(() {
      _data = rowsAsListOfMaps;
      _chartKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weakness Chart'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _showAddNewLineDialog();
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Center(
        child: _data == null
            ? const CircularProgressIndicator()
            : SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Weakness Chart'),
                legend: Legend(
                  isVisible: true,
                  shouldAlwaysShowScrollbar: true,
                ),
                series: <ChartSeries>[
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(data['EST. VALUE IN CURRENCY'] as String),
                    name: 'Entered value',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(
                            data['STATS PROB % ( 3 POINT BASED)'] as String),
                    name: '3 point based', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(data['MIN PROB ADJUSTED VALUE'] as String),
                    name: 'MIN PROB ADJUSTED VALUE', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(data['MAX PROB ADJUSTED VALUE'] as String),
                    name: 'MAX PROB ADJUSTED VALUE', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(
                            data['AVERAGE PROB ADJUSTED VALUE'] as String),
                    name: 'AVERAGE PROB ADJUSTED VALUE', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(
                            data['REALISTIC PROB ADJUSTED VALUE'] as String),
                    name: 'REALISTIC PROB ADJUSTED VALUE', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(data['3 POINT BASED PROB ADJUSTED VALUE']
                            as String),
                    name:
                        '3 POINT BASED PROB ADJUSTED VALUE', // Name of the series
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        double.parse(
                            data['PERT BASED PROB ADJUSTED VALUE'] as String),
                    name:
                        'PERT BASED PROB ADJUSTED VALUE', // Name of the series
                  ),
                ],
              ),
      ),
    );
  }
}
