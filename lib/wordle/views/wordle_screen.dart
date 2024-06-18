import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/app_colors.dart';
import 'package:flutter_wordle/wordle/data/word_list.dart';
import 'package:flutter_wordle/wordle/models/letter_model.dart';
import 'package:flutter_wordle/wordle/models/word_model.dart';
import 'package:flutter_wordle/wordle/widgets/board.dart';
import 'package:flutter_wordle/wordle/widgets/keyboard.dart';

//game states of our worlde screen
enum GameStatus { playing, submitting, lost, won }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  //init game status
  GameStatus _gameStatus = GameStatus.playing;

  //generate board of words
  final List<Word> _board = List.generate(
      6, //6 rows for 6 guesses
      (index) => Word(
          letters:
              List.generate(5, (index) => Letter.emtpy())) //each column woul
      );
  //list of list of globalkey flipcard state
  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    6,
   (_) => List.generate(5,(_)=> GlobalKey<FlipCardState>()),);
  //hold current index
  int _currentWordIndex = 0;
  //to get current word create a getter

  Word? get _currentWord =>
      //if current word index is inside board length (less than 6) return currentWord else null
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.FromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase());



  final Set<Letter> _keyBoardLetters = {};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wordlelyloo',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 4),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board , flipCardKeys : _flipCardKeys), //board widget constructed with board list obj
          SizedBox(height: 60),
          Keyboard(
              letters: _keyBoardLetters,
              onKeyTapped: _onKeyTapped,
              onDeleteTapped: _onDeleteTapped,
              onEnterTapped: _onEnterTapped),
        ],
      ),
    );
  }

  void _onKeyTapped(String val) {
    //check if we palying the game
    if (_gameStatus == GameStatus.playing) {
      //rebuilt ui w setstate
      setState(() {
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      //rebuilt ui w setstate
      setState(() {
        _currentWord!.removeLetter();
      });
    }
  }

  Future<void> _onEnterTapped() async {
    //check we playing and word has no empty letters
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.emtpy())) {
      _gameStatus = GameStatus.submitting; //to stop user from spaming enter
      //roll through all currentword letter and compare
      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          //if current letter in right place , turn its status into correct by comparing it w currentsolutionletter
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.correct);
          }
          //if solution contains that letter
          else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          }
          //if u suck
          else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        
      }
        //retrieve letter pressed from the kb set
        

        

        //check if win or lose and do stuff
        _checkIfWinOrLoss();
      
    }

    //retrieve current word and iterate over both word and solution

    {
      //rebuilt ui w setstate
      // setState(() {
      //   _currentWord?.addLetter(val);
      // });
    }
  }

  void _checkIfWinOrLoss() {
    //check if current word winnin word
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.none,
        duration: const Duration(minutes: 1), //TODO :  change duration bcs wtf
        backgroundColor: correctColor,
        content: Text(
          "ATCHIWAYWAYWA",
          style: TextStyle(backgroundColor: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: _restart,
          textColor: Colors.white,
          label: 'new game ?? btw the answer was ${_solution.wordString}' ,
        ),
      ));
    }
    //if u failed (aka u inputted ur last word )
    else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost; //boohoo
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.none,
        duration: const Duration(minutes: 1), //TODO :  change duration bcs wtf
        backgroundColor: correctColor,
        content: Text(
          "YOU SUCK",
          style: TextStyle(backgroundColor: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: _restart,
          textColor: Colors.white,
          label: 'new game ??',
        ),
      ));
    }
    //if ur still alive
    else {
      _gameStatus = GameStatus.playing;
    }
    //inc indx
    _currentWordIndex += 1;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      //solu to new random word
      _solution = Word.FromString(
          fiveLetterWords[Random().nextInt(fiveLetterWords.length)]
              .toUpperCase());
      _board
        ..clear() //double dot to call diff methods on same obj
        ..addAll(List.generate(
            6,
            (index) =>
                Word(letters: List.generate(5, (index) => Letter.emtpy()))));
    });


    _flipCardKeys
      ..clear()
      ..addAll(
        List.generate(
          6,
           (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()))
      );

    _keyBoardLetters.clear();
  }
}
