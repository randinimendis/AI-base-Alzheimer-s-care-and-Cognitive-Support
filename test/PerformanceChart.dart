import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceCharts extends StatefulWidget {
  const PerformanceCharts({Key? key}) : super(key: key);

  @override
  State<PerformanceCharts> createState() => _PerformanceChartsState();
}

class _PerformanceChartsState extends State<PerformanceCharts> {
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadPerformanceRecords();
  }

  Future<void> _loadPerformanceRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('performance_records') ?? [];

    final decoded = rawList
        .map((r) {
          try {
            return jsonDecode(r) as Map<String, dynamic>;
          } catch (_) {
            return null;
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    decoded.sort((a, b) => DateTime.parse(a['timestamp'])
        .compareTo(DateTime.parse(b['timestamp'])));

    setState(() {
      _records = decoded;
    });
  }

  List<FlSpot> _generateLineData(String key) {
    final spots = <FlSpot>[];
    for (int i = 0; i < _records.length; i++) {
      final record = _records[i];
      final isCorrect = record[key] == true ? 1.0 : 0.0;
      spots.add(FlSpot(i.toDouble(), isCorrect));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Performance Over Time')),
      body: _records.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Puzzle Accuracy Over Time',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                      height: 200, child: _buildLineChart('puzzleCorrect')),
                  SizedBox(height: 20),
                  Text('Speech Accuracy Over Time',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                      height: 200, child: _buildLineChart('speechCorrect')),
                ],
              ),
            ),
    );
  }

  Widget _buildLineChart(String key) {
    final data = _generateLineData(key);

    if (data.isEmpty) {
      return Center(child: Text("No data available"));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            barWidth: 3,
            color: key == 'puzzleCorrect' ? Colors.blue : Colors.orange,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                if (value == 1) return Text('Correct');
                if (value == 0) return Text('Wrong');
                return SizedBox();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) => Text('${value.toInt() + 1}'),
            ),
          ),
        ),
        minY: 0,
        maxY: 1,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
