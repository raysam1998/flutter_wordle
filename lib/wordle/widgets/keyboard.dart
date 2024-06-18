import 'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/models/letter_model.dart';

const _qwerty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L','ENTER'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M','DEL']
   
];

const _azerty = [
  'A', 'Z', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
  'Q', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L','Enter', 'M',
  'W', 'X', 'C', 'V', 'B', 'N',
   'Delete'
];


class Keyboard extends StatelessWidget {
  //create it w 3 callbacks
  const Keyboard({
    Key? key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
  }) : super(key:key);

  final void Function(String) onKeyTapped;

  final VoidCallback onDeleteTapped;

  final VoidCallback onEnterTapped;

  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _qwerty
      .map(
        (keyRow) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: keyRow.map(
            (letter) {
              if(letter == 'DEL'){
                return _KeyboardButton.delete(onTap: onDeleteTapped);
              }else if(letter == 'ENTER') {
                return _KeyboardButton.enter(onTap: onEnterTapped);
              }

              //grab last color and change bg accordignly
              final letterKey = letters.firstWhere(
                (element) => element.val == letter,
                orElse: () => Letter.emtpy(),);

              return _KeyboardButton(
              onTap: () => onKeyTapped(letter),
              //if letter not empty add correspondiong bg color , else gray
              backgroundColor: letterKey != Letter.emtpy()
              ? letterKey.backgroundColor//if non empty do its bg color
              : Colors.grey,//else grey
              letter: letter);
            }
            
          ).toList(),

        )).toList()
    );
  }

}


class _KeyboardButton extends StatelessWidget {
  final double height;
  
  final double width;
  
  final VoidCallback onTap;
  
  final Color backgroundColor;
  
  final String letter;

  const _KeyboardButton({
    Key? key,
    this.height = 42,
    this.width = 42,
    required this.onTap,
    required this.backgroundColor,
    required this.letter}) : super (key:key);


    factory _KeyboardButton.delete({
      required VoidCallback onTap,
    }) =>
        _KeyboardButton(onTap: onTap, backgroundColor: Colors.grey, letter: 'DEL',width: 62);//return custom btn
    
    factory _KeyboardButton.enter({
      required VoidCallback onTap,
    }) =>
        _KeyboardButton(onTap: onTap, backgroundColor: Colors.grey, letter: 'ENTER',width: 62);//return custom btn
    


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
      child: Material(
        color :backgroundColor,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap,
          child:Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800),),
          )),//inkwell gives a nice woosh effect on pressing on the button
      ),
    );
  }

}