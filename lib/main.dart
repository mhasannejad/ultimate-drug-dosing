import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Drug dosage calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selected = 'Acetaminophen';
  List<String> _items = ['Acetaminophen', 'Ibuprofen'];

  Future<List<String>> readDrugNames() async {
    final String response =
        await rootBundle.loadString('assets/jsonfiles/drugs_list.json');
    final data = await json.decode(response);
    final List<String> names = [for (var item in data) item['name']];

    return names;
  }

  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  double _result = 0;
  String _command = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDrugNames().then((value) {
      setState(() {
        print(value);
        _items = value;
      });
    });
  }

  final List<String> _items2 = [
    'Metronidazole',
    'Penicillin V',
    'Amoxicillin 125',
    'Amoxicillin 250',
    'Amoxicillin 200',
    'Amoxicillin 400',
    'Azithromycin 100',
    'Azithromycin 200',
    'Cefixime',
    'Cephalexin 125',
    'Cephalexin 250',
    'Clarithromycin 125',
    'Clarithromycin 250',
    'Co- amoxiclave 156',
    'Co- amoxiclave 312',
    'Co- amoxiclave 228',
    'Co- amoxiclave 457',
    'Co- amoxiclave 643',
    'Co- trimoxazole',
    'Erythromycin',
    'fexofenadine'
  ];

  Future<void> _calculate() async {
    final String jsonString =
        await rootBundle.loadString('assets/jsonfiles/drugs_list.json');
    final List<dynamic> data = jsonDecode(jsonString);
    print(data[0]['name']);
    final Map<String, dynamic> drug = data.firstWhere((element) =>
        element['name'].toString().toLowerCase() == (selected.toLowerCase()));
    print(drug);
    if (drug['type'] == 'weight') {
      double weight = double.parse(_weightController.text);
      final double dosage = weight * double.parse(drug['factor']);
      setState(() {
        _result = dosage;
        _command = drug['info'];
      });
    } else if (drug['type'] == 'static') {
      setState(() {
        _result = double.nan;
        _command = drug['info'];
      });
    } else if (drug['type'] == 'range_age') {
      double age = double.parse(_ageController.text);
      for (var range in drug['ranges']) {
        if (range['min'] <= age && age <= range['max']) {
          setState(() {
            _result = double.nan;
            _command = range['info'];
          });
          print(range);
        }
      }
    }else if (drug['type'] == 'range_weight') {
      double weight = double.parse(_weightController.text);
      for (var range in drug['ranges']) {
        if (range['min'] <= weight && weight <= range['max']) {
          setState(() {
            _result = double.nan;
            _command = range['info'];
          });
          print(range);
        }
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: _items.length == 0
                  ? Container()
                  : DropdownButton<String>(
                      value: selected,
                      onChanged: (String? newValue) {
                        setState(() {
                          selected = newValue!;
                        });
                      },
                      items:
                          _items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Weight',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,

                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'months'
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _calculate,
                child: Text('Calculate'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Result: ${_result.toStringAsFixed(2)} mg \n $_command',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
