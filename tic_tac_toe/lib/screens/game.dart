import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  String resultDeclaration ='';
  bool oTurn = true;
  List<String> display =['','','','','','','','',''];
  bool firstAttempt = true;

  static const maxSeconds =30;
  int seconds = maxSeconds;
  Timer? timer;

List<int> matchedIndexes = [];

  int filledBoxes =0;
  bool WinnerFound = false;

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(seconds> 0){
          seconds--;
        }else{
          stopTimer();
        }
      });
    });
  }

  //stop the timer

  void stopTimer(){
    resetTimer();
    timer?.cancel();
  }

  //reset the timer
  void resetTimer(){
    seconds = maxSeconds;
  }

  void _clearBoard(){
    setState(() {
      for(var i=0;i<9;i++){
      display[i] ='';
    }
    resultDeclaration = '';
    });
    filledBoxes =0;

  }

  void _tapped(index){
     final isRunning = timer==null ? false : timer!.isActive;

     if(isRunning){
        setState(() {
      if(oTurn && display[index]==''){
        display[index] = 'O';
        filledBoxes++;
      }else if(!oTurn && display[index]==''){
        display[index] = 'X';
        filledBoxes++;
      }
      oTurn = !oTurn;
      _checkWinner();
    });
     }
  }
  void _checkWinner(){
    //check rows 

    //1st row
    if(
      display[0]==display[1] && 
      display[0]==display[2] &&
       display[0]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[0] + ' Wins!';
          stopTimer();
          matchedIndexes.addAll([0,1,2]);
        });
       }

       //2nd row
        if(
      display[3]==display[4] && 
      display[3]==display[5] &&
       display[3]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[3] + ' Wins!';
           stopTimer();
          matchedIndexes.addAll([3,4,5]);
        });
       }
       
       //3rd row
        if(
      display[6]==display[7] && 
      display[6]==display[8] &&
       display[6]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[6] + ' Wins!';
           stopTimer();
          matchedIndexes.addAll([6,7,8]);
        });
       }

       //for columns check the conditions

       //1st column
       if(
      display[0]==display[3] && 
      display[0]==display[6] &&
       display[0]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[0] + ' Wins!';
           stopTimer();
          matchedIndexes.addAll([0,1,2]);
        });
       }
       //2nd column
       if(
      display[1]==display[4] && 
      display[1]==display[7] &&
       display[1]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[1] + ' Wins!';
           stopTimer();
          matchedIndexes.addAll([1,4,7]);
        });
       }
       //3rd column
       if(
      display[2]==display[5] && 
      display[2]==display[8] &&
       display[2]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[2] + ' Wins!';
           stopTimer();
          matchedIndexes.addAll([2,5,8]);
        });
       }
      //1st diagonal
       if(
      display[0]==display[4] && 
      display[0]==display[8] &&
       display[0]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[0] + ' -Wins!';
           stopTimer();
          matchedIndexes.addAll([0,4,8]);
        });
       }

       //2nd diagonal
       if(
      display[2]==display[4] && 
      display[2]==display[6] &&
       display[2]!= ''){
        setState(() {
          resultDeclaration = 'Player '+ display[2] + ' -Wins!';
           stopTimer();
          matchedIndexes.addAll([2,4,6]);
        });
       }

       else if(!WinnerFound && filledBoxes == 9){
        setState(() {
          resultDeclaration = 'Nobody Wins!';
           stopTimer();
        
        });
       }
  }

static var customFontWhite = GoogleFonts.coiny(
textStyle:TextStyle(
  color: Colors.white,
  fontSize:28,
  letterSpacing: 3.0
)
);

Widget _buildTimer(){
  final isRunning = timer==null ? false : timer!.isActive;
  return isRunning ? SizedBox(
    width:100,
    height: 100,
    child:Stack(
      fit:StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: 1- seconds/maxSeconds,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 8,
          backgroundColor: MainColor.accentColor,

        ),
        Center(
          child:Text('$seconds', style:TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold
          ))
        )
      ],
    )
  )
  : ElevatedButton(
                      onPressed: (){
                        _clearBoard();
                        startTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16) ),
                       child: Text(firstAttempt ? 'Start ':'Play Again',
                       style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                       ),
                       ));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe',style: customFontWhite,),
        leading: Icon(Icons.games),
      ),
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          children: [
            // Expanded(
            //   flex: 0,
            //   child: Center(child: Text('Tic Tac Toe',style:customFontWhite))),
               Expanded(
                flex: 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
                 itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap:(){
                              _tapped(index);
                    },
                    child:Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:Border.all(
                          width:5.0,
                          color:MainColor.primaryColor,
                        ),
                          color: matchedIndexes.contains(index)
                          ?MainColor.accentColor :  MainColor.SecondaryColor
                      ),
                      child: Center(child: Text(display[index],style:GoogleFonts.coiny(
                        textStyle: TextStyle(
                          fontSize: 60,
                          color:MainColor.primaryColor
                        )
                        ))),
                    )
                  );
                 })),
                 
               Expanded(
                flex:1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(resultDeclaration,style: customFontWhite,),
                    SizedBox(height: 10.0,),
                   _buildTimer(),
                  ],
                ))),
          ],
        ),
      )
    );
  }
}