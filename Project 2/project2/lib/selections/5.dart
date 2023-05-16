import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart';

class Weakness extends StatefulWidget {
  const Weakness({Key? key}) : super(key: key);

  @override
  State<Weakness> createState() => _WeaknessState();
}

class _WeaknessState extends State<Weakness> {
  List<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    convertCSVToJson();
  }

  Future<void> _showAddNewLineDialog() async {
    Map<String, String> newData = {
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
                  newData['PARAM NAME'] = value;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'EST. VALUE IN CURRENCY'),
                onChanged: (value) {
                  newData['EST. VALUE IN CURRENCY'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'MIN PROB %'),
                onChanged: (value) {
                  newData['MIN PROB %'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'REALISTIC PROB %'),
                onChanged: (value) {
                  newData['REALISTIC PROB %'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'MAX PROB %'),
                onChanged: (value) {
                  newData['MAX PROB %'] = value;
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
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
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
