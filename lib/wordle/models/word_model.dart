import 'package:equatable/equatable.dart';
import 'package:flutter_wordle/wordle/models/letter_model.dart';

class Word extends Equatable{
  //list of words 
  const Word({required this.letters});
  //construct word from string using map
  factory Word.FromString(String word) =>
    Word(letters: word.split('').map((e) => Letter(val: e)).toList());
    
  final List<Letter> letters;
  //in order to return string
  //loop through all values of letter then join these sumbiches
  String get wordString => letters.map((e) => e.val).join();


  void addLetter(String val){
    //check where empty string this is where we want to add the letter
    //such as wanting to add the letter B to BOB , it checks the index of our empty string that we init the word with , it being B+O+B+'empty string'
    //it will add a letter to D
    final currentIndex = letters.indexWhere((element) => element.val.isEmpty);
    //simple check then implement
    if(currentIndex != -1){
      //create letter obj and input it 
      //since wordle letter have a set length of 5 , if it returns-1 then we cannot add any mre letters
      letters[currentIndex] = Letter(val: val);
    }
  }

  //removing the letter is done by
  void removeLetter(){
    //1- retrieving the last added letter index which can be found by looking for the last index where its element isnt empty
    final recentLetterIndex = letters.lastIndexWhere((element) => element.val.isNotEmpty);
    //check if there are letters so index not -1
    if(recentLetterIndex != -1){
      letters[recentLetterIndex] = Letter.emtpy();//add in an empty letter
    }
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [letters];














  
}