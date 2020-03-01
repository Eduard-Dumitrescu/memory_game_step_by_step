import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:memory_game_step_by_step/utils.dart';

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
      centerTitle: true,
    );
  }

  Widget _mainBody() {
    return Container(
      //set width and height so that rows and columns will behave
      width: Utils.deviceWidth(context),
      height: Utils.deviceHeightWithoutAppBar(context),
      child: Board(),
    );
  }
}

class Board extends StatefulWidget {
  final Color mainColor;
  final Color frontCardColor;
  final Color backCardColor;
  final double numOfElements;
  final double numOfColumns;

  const Board(
      {Key key,
      this.mainColor = Colors.green,
      this.frontCardColor = Colors.redAccent,
      this.backCardColor = Colors.yellow,
      this.numOfElements = 16,
      this.numOfColumns = 4})
      : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.mainColor,
      child: _gridWidget(),
    );
  }

  Widget _gridWidget() {
    List<Widget> rows = List<Widget>();

    for (int i = 0; i <= widget.numOfElements / widget.numOfColumns; i++) {
      List<Widget> elements = List<Widget>();

      for (int j = 0; j <= widget.numOfColumns; j++) {
        elements.add(Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _card(),
          ),
        ));
      }
      rows.add(Flexible(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: elements,
        ),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }

  Widget _card() {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        color: widget.frontCardColor,
      ),
      back: Container(
        color: widget.backCardColor,
      ),
    );
  }
}
