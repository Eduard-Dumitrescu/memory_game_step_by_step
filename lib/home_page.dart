import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_game_step_by_step/card_model.dart';
import 'package:memory_game_step_by_step/icon_assets.dart';
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
  final int numOfElements;
  final int numOfColumns;

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
  List<CardModel> _cards;
  List<CardModel> _flippedCards;

  @override
  void initState() {
    _flippedCards = List<CardModel>();
    final int rnd =
        Random().nextInt(IconAssets.assets.length - 1 - widget.numOfElements);

    _cards = List<CardModel>();
    List<int>.generate(widget.numOfElements, (i) => i + 1)
        .map((num) => num % 2 == 0 ? num - 1 : num)
        .forEach((item) => _cards.add(
              CardModel(item, IconAssets.assets[item + rnd],
                  GlobalKey<FlipCardState>()),
            ));
    _cards.shuffle(Random.secure());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.mainColor,
      child: _gridWidget(),
    );
  }

  Widget _gridWidget() {
    List<Widget> rows = List<Widget>();

    for (int i = 0; i < widget.numOfElements / widget.numOfColumns; i++) {
      List<Widget> elements = List<Widget>();

      for (int j = 0; j < widget.numOfColumns; j++) {
        final int index = i * widget.numOfColumns + j;

        elements.add(Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _card(_cards[index]),
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

  Widget _card(CardModel card) {
    return FlipCard(
      key: card.cardKey,
      flipOnTouch: false,
      direction: FlipDirection.HORIZONTAL,
      front: InkWell(
        onTap: () async {
          if (_flippedCards.length != 2) {
            card.cardKey.currentState.toggleCard();
            _flippedCards.add(card);
            if (_flippedCards.length == 2)
              //delay so player can't click new card before animation finishes or something like that
              Future.delayed(
                  const Duration(milliseconds: 500), () async => _maybeReset());
          }
        },
        child: Container(
          color: widget.frontCardColor,
        ),
      ),
      back: Container(
        color: widget.backCardColor,
        child: SvgPicture.asset(card.imagePath),
      ),
    );
  }

  _maybeReset() {
    if (_flippedCards[0].id != _flippedCards[1].id) {
      _flippedCards.forEach((card) => card.cardKey.currentState.toggleCard());
    }
    _flippedCards.clear();
  }
}
