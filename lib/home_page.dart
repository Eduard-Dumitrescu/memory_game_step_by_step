import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body:
            _mainBody() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(widget.title),
    );
  }

  Widget _mainBody() {
    return Container();
  }
}
