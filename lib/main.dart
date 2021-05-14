import 'package:accounting/registry/registry.dart';
import 'package:accounting/registry/registry_item.dart';
import 'package:accounting/registry/registry_list.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'forms/PayItemForm.dart';

void main() {
  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  late final String title;
  final IRegistry registrySource = SqliteDataRegistry();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _createNewPay(context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return PayItemForm(
              PayItem(
                  id: -1,
                  date: DateTime.now(),
                  paySum: Decimal.zero
              ),
          );
        })
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.registrySource.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: RegistryList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewPay(context),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildRegistryItem(BuildContext context, payItem) {
    return ListTile(
      title: Text(payItem.paySum.toString()),
      subtitle: Text(payItem.category),
    );
  }

  List<PayItem> getEvents(DateTime start, DateTime end) {
    var data = widget.registrySource.load(start, end);
    if (data == null) {
      return [];
    }
    return data;
  }
}
