import 'package:flutter/material.dart';

class Quizapp extends StatefulWidget{
  const Quizapp({super.key});

@override
    State createState() => _Quizapp();
  }

class _Quizapp extends State{
  List<Map> allquestions = [
    {
      "question": "who is the founder of microsoft?",
      "options":["Steve jobs","Jaff Bezos", "Bill Gates", "Elon musk"],
      "answerIndex":2,
    },

    {
      "question": "who is the founder of Apple?",
      "options":["Steve jobs","Jaff Bezos", "Bill Gates", "Elon musk"],
      "answerIndex":0,
    },
    {
      "question": "who is the founder of Amazon?",
      "options":["Steve jobs","Jaff Bezos", "Bill Gates", "Elon musk"],
      "answerIndex":1,
    },
    {
        "question": "who is the founder of Tesla?",
      "options":["Steve jobs","Jeff Bezos", "Bill Gates", "Elon musk"],
      "answerIndex":3,
    },
    {
        "question": "who is the founder of Google?",
      "options":["Steve jobs","Jaff Bezos", "Bill Gates", "Elon musk"],
      "answerIndex":1,
    },
  ];
  bool questionScreen = true;
  int questionIndex = 0;
  int selectedAnswerIndex = -1;
  int noOfCorrectAnswers = 0;

  WidgetStateProperty<Color?> checkAnswer(int buttonIndex){
    if(selectedAnswerIndex != -1){
      if(buttonIndex ==
       allquestions[questionIndex]["answerIndex"]){
        return const WidgetStatePropertyAll(Colors.green);
      }
      else if(buttonIndex == selectedAnswerIndex){
        return const WidgetStatePropertyAll(Colors.red);
      }
      else{
        return const WidgetStatePropertyAll(null);
      }
    }
    else{
      return const WidgetStatePropertyAll(null);
    }
  }
    void validataCurrentPage(){
      if (selectedAnswerIndex == -1){
        return;
      }
      if(selectedAnswerIndex == allquestions[questionIndex]["answerIndex"]){
      noOfCorrectAnswers += 1;
      }
      if(selectedAnswerIndex !=-1){
        if(questionIndex==allquestions.length-1){
          setState((){
            questionScreen = false;
          });
        }
          selectedAnswerIndex = -1;
          setState((){
            questionIndex += 1;
          });
        }
      }




      Scaffold isQuestionScreen(){
        if(questionScreen == true){
          return Scaffold(
            appBar: AppBar(
              title: const Text("QuizApp",
              style: TextStyle(fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.orange,
              ),
              ),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Questions: ",
                  style:TextStyle( fontSize:25,
                  fontWeight: FontWeight.w600
                  ),
                  ),
                  Text("${questionIndex + 1}/${allquestions.length}",
                  style:const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 380,
                  height: 50,
                  child: Text(
                    allquestions[questionIndex]["question"],
                    style: const TextStyle(fontSize: 23,
                    fontWeight: FontWeight.w400
                    ),

                  ),
                ),
                const SizedBox(
                height:30,),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: checkAnswer(0),
                  ),
                  onPressed: () {
                    if(selectedAnswerIndex == -1){
                      setState(() {
                        selectedAnswerIndex = 0;
                      });
                    }
                  },

                  child: Text(
                    "A.${allquestions[questionIndex]["options"][0]}",
                    style: const TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.normal,
                    ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style:ButtonStyle( backgroundColor: checkAnswer(1),
                    ),
                    onPressed: (){
                      if(selectedAnswerIndex == -1){
                        setState(() {
                          selectedAnswerIndex = 1;
                        });
                      }
                    } ,
                    child: Text(
                      "B.${allquestions[questionIndex]["options"][1]}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight:FontWeight.normal,
                      ),
                    ), 
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style:ButtonStyle(
                      backgroundColor: checkAnswer(2),
                    ),
                    onPressed: () {
                      if(selectedAnswerIndex == -1){
                        setState(() {
                          selectedAnswerIndex = 2;
                        });
                      }
                    },
                   child: Text(
                    "C.${allquestions[questionIndex]["options"][2]}",
                    style:const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                   ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(style: ButtonStyle(
                      backgroundColor: checkAnswer(3)
                    ),
                    onPressed: (){
                      if(selectedAnswerIndex == -1){
                        setState(() {
                          selectedAnswerIndex =3;
                        });
                      }
                    
                    },
                    child: Text(
                      " D.${allquestions[questionIndex]["options"][3]}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      ),
                    ),
                     
              ],
                    
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                validataCurrentPage();
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.forward,
              color:Colors.orange
              ),
              ),
          );
        }
      
      else{

       return Scaffold(
        appBar: AppBar(
          title: const Text("QuizApp",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height:30,
            ),
            Image.network("https://i.pinimg.com/originals/47/4c/84/474c8409b925e086e41c21304699fc88.png",height: 500,
            width: 380, 
            ),
            const Text("Congratulation!!!",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("You heve Completed the Quiz",
            style: TextStyle(
              fontSize:23,
            fontWeight: FontWeight.w500,
            ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("$noOfCorrectAnswers/${allquestions.length}"),
            ElevatedButton(onPressed: (){
              questionIndex = 0;
              questionScreen = true;
              noOfCorrectAnswers = 0;
              selectedAnswerIndex = -1;

              setState(() {});

            }, child: const Text("Reset",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.orange,
            ), 
            )
            )
          ],
        ),
       );
      }
      }
      
      
      
      
    
  
  

@override 
Widget build(BuildContext context){
  return isQuestionScreen();
}

}