import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/models/letter_model.dart';
import 'package:flutter_wordle/wordle/models/word_model.dart';
import 'package:flutter_wordle/wordle/widgets/board_tile.dart';

class Board extends StatelessWidget {
 const Board({
    Key? key,
    required this.board,
    required this.flipCardKeys,
  }) : super (key:key);
 

  final List<Word> board;

  final  List<List<GlobalKey<FlipCardState>>> flipCardKeys;
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: board
            .asMap()
            //in order to construct the board
            //we add in a row for each word FIRST then we map each letter into a custom widget called
            //board tile !
            .map(
              (i ,word) => MapEntry(
                i,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: word.letters
                  .asMap()
                  //the children of the board will iterate through every letter and create a custom board with them yipy!
                    .map(
                      (j,letter) => MapEntry(
                        j, FlipCard(
                          key: flipCardKeys[i][j],
                          flipOnTouch: false,
                          direction: FlipDirection.HORIZONTAL,
                          front: BoardTile(
                            letter: Letter(
                              val: letter.val,
                              status: LetterStatus.initial)),
                           back: BoardTile(letter: letter),)
                        )
                    ).values
                    .toList(),
                ),
              )
            ).values.toList(),
    );
  }
}
