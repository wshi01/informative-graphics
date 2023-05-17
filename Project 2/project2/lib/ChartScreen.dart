import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csv/csv.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Map<String, dynamic>>? _data;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    loadCSVFromDirectory();
  }

  Future<void> loadCSVFromDirectory() async {
    Directory? directoryPath = await getExternalStorageDirectory();
    String csvFilePath = '${directoryPath?.path}/Weakness Analysis Data.csv';
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
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weakness Chart'),
      ),
      body: Center(
        child: _data == null
            ? const CircularProgressIndicator()
            : SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Weakness Chart'),
                legend:
                    Legend(isVisible: true, shouldAlwaysShowScrollbar: true),
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
                  // Add other BarSeries here
                ],
              ),
      ),
    );
  }
}
