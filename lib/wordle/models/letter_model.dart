import 'package:equatable/equatable.dart';


//stats of letter

import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/app_colors.dart';enum LetterStatus {initial , notInWord , inWord , correct}


class Letter extends Equatable{
  const Letter({
    required this.val,
    this.status = LetterStatus.initial,
  });


  //constructor w empty vals
  factory Letter.emtpy() => const Letter(val : '');

  final String val;
  final LetterStatus status;


  Color get backgroundColor {
    switch (status){
      
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.notInWord:
         return notInWordColor;
      case LetterStatus.inWord:
         return inWordColor;
      case LetterStatus.correct:
         return correctColor;
        // TODO: Handle this case.
    }
  }

  Color get borderColor {
    switch(status){
      
      case LetterStatus.initial:
        return Colors.grey;
      default :
      return Colors.transparent;
        // TODO: Handle this case.
    }
  }



  //return copy of letter since letter immutable
  Letter copyWith({
    //vars of method
    String? val,
    LetterStatus? status,
  }){
    //actually method body where we return copied letter
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status);//
    
  }


  @override
  List<Object?> get props => [val,status];
  
}