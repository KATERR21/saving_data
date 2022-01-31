import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const FlutterDemo());
}

class FlutterDemo extends StatelessWidget {
  const FlutterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сохранение и загрузка данных',
      home: MyHomePage(storage: CounterStorage()),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counterq.txt');
  }
  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

//

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  int _counterq = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counterq = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counterq++;
    });
    return widget.storage.writeCounter(_counterq);
  }
  //
  int _counter = 0;

  @override
  void State() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  void _increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сохранение и загрузка данных'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _increment,
              child: const Text('First button'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Second button'),
            ),
            const SizedBox(height: 30),
            Text(
              'Нажатий на кнопку "First button": $_counter', style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            Text(
              'Нажатий на кнопку "Second button": $_counterq', style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}