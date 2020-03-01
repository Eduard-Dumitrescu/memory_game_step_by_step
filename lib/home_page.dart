import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_game_step_by_step/card_model.dart';
import 'package:memory_game_step_by_step/icon_assets.dart';
import 'package:memory_game_step_by_step/utils.dart';

enum PlayerMode {
  SinglePlayer,
  TwoPlayers,
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlayerMode _playerMode = PlayerMode.SinglePlayer;

  GlobalKey p1k = new GlobalKey();
  GlobalKey p2k = new GlobalKey();

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
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.filter_1,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _playerMode = PlayerMode.SinglePlayer;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_2,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _playerMode = PlayerMode.TwoPlayers;
            });
          },
        ),
      ],
    );
  }

  Widget _mainBody() {
    return Container(
      //set width and height so that rows and columns will behave
      width: Utils.deviceWidth(context),
      height: Utils.deviceHeightWithoutAppBar(context),
      child: _content(),
    );
  }

  Widget _content() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    switch (_playerMode) {
      case PlayerMode.SinglePlayer:
        return Board();
      case PlayerMode.TwoPlayers:
        return orientation == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Transform.rotate(
                          angle: pi,
                          child: Board(
                            key: p1k,
                          ))),
                  Expanded(
                      flex: 1,
                      child: Board(
                        key: p2k,
                      )),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Board(
                        key: p1k,
                      )),
                  Expanded(
                      flex: 1,
                      child: Board(
                        key: p2k,
                      )),
                ],
              );
    }
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
  final ValueNotifier<String> _message = ValueNotifier<String>("");
  int _totalFlippedCards = 0;

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 9, child: _gridWidget()),
          ValueListenableBuilder<String>(
              valueListenable: _message,
              builder: (context, message, _) {
                return message.isEmpty
                    ? Container()
                    : Flexible(
                        flex: 1,
                        child: Center(
                          child: Text(
                            message,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
              }),
          Flexible(
            flex: 1,
            child: RaisedButton(
              onPressed: () async {
                setState(() {
                  _resetEverything();
                });
              },
              child: Text(
                "Reset",
              ),
            ),
          ),
        ],
      ),
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
      front: Material(
        //add material for ripple
        color: widget.frontCardColor,
        child: InkWell(
          onTap: () async {
            if (_flippedCards.length != 2) {
              card.cardKey.currentState.toggleCard();
              _flippedCards.add(card);
              _totalFlippedCards++;
              if (_flippedCards.length == 2)
                //delay so player can't click new card before animation finishes or something like that
                Future.delayed(const Duration(milliseconds: 500),
                    () async => _maybeReset());
            }
          },
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
      _totalFlippedCards -= 2;
    }
    _flippedCards.clear();
    if (_totalFlippedCards == _cards.length) {
      _message.value = "You won!";
    }
  }

  _resetEverything() {
    _message.value = "";
    _totalFlippedCards = 0;

    _cards.forEach((card) {
      if (!card.cardKey.currentState.isFront) {
        card.cardKey.currentState.toggleCard();
      }
    });

    //delay for animation finish
    Future.delayed(const Duration(milliseconds: 500), () async {
      _flippedCards.clear();
      _cards.shuffle(Random.secure());
    });
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }
}
