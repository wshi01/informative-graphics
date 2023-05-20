import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csv/csv.dart';

class ChartScreen2 extends StatefulWidget {
  const ChartScreen2({Key? key}) : super(key: key);

  @override
  _ChartScreen2State createState() => _ChartScreen2State();
}

class _ChartScreen2State extends State<ChartScreen2> {
  List<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    loadCSVFromDirectory();
  }

  @override
  void dispose() {
    _data = null;
    super.dispose();
  }

  Future<void> loadCSVFromDirectory() async {
    Directory? directoryPath = await getExternalStorageDirectory();
    String csvFilePath = '${directoryPath?.path}/Strength Analysis Data.csv';
    File file = File(csvFilePath);
    if (!file.existsSync()) {
      print('CSV file does not exist!');
      return;
    }

    String csvData = await file.readAsString();
    convertCSVToJson(csvData);
  }

  void convertCSVToJson(String csvData) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strength Chart'),
      ),
      body: Center(
        child: _data == null
            ? const CircularProgressIndicator()
            : SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Strength Chart'),
                legend:
                    Legend(isVisible: true, shouldAlwaysShowScrollbar: true),
                series: <ChartSeries>[
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['EST. VALUE IN CURRENCY'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'Entered value',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['STATS PROB % ( 3 POINT BASED)'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: '3 point based',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['MIN PROB ADJUSTED VALUE'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'MIN PROB ADJUSTED VALUE',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['MAX PROB ADJUSTED VALUE'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'MAX PROB ADJUSTED VALUE',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['AVERAGE PROB ADJUSTED VALUE'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'AVERAGE PROB ADJUSTED VALUE',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['REALISTIC PROB ADJUSTED VALUE'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'REALISTIC PROB ADJUSTED VALUE',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['3 POINT BASED PROB ADJUSTED VALUE']
                                as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: '3 POINT BASED PROB ADJUSTED VALUE',
                  ),
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _data!,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['PARAM NAME'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) {
                      try {
                        return double.parse(
                            data['PERT BASED PROB ADJUSTED VALUE'] as String);
                      } catch (e) {
                        return 0.0;
                      }
                    },
                    name: 'PERT BASED PROB ADJUSTED VALUE',
                  ),
                ],
              ),
      ),
    );
  }
}
