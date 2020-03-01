import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final String imagePath;
  final GlobalKey<FlipCardState> cardKey;

  CardModel(this.id, this.imagePath, this.cardKey);
}
