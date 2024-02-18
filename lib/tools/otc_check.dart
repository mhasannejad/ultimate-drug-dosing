
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonSearchScreen extends StatefulWidget {
  @override
  _JsonSearchScreenState createState() => _JsonSearchScreenState();
}

class _JsonSearchScreenState extends State<JsonSearchScreen> {
  List<String> _jsonData = []; // List to store data from JSON
  List<String> _filteredData = []; // Filtered data for auto-completion
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    final String jsonString =
    await rootBundle.loadString('assets/jsonfiles/otc.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _jsonData = jsonList.cast<String>();
      _filteredData = _jsonData; // Initialize filtered data with all items
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _jsonData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check OTC',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterData,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredData[index]),
                  // Add navigation logic here if needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
