import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {

  final String ?  title;
  final String ?  description;

  TaskCard({this.title,this.description});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(vertical: 24.0,horizontal: 24.0),
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0)
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text( title ?? 'Get Started',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Color(0xFF211551)),),
        ),
        Text(description ??'Start adding new Tasks',style: TextStyle(fontSize: 14.0,color: Color(0xFF868290),height: 1.5),
              
        ),
              ],),
    );
  }
}


class TodoWidget extends StatelessWidget {
  
  final String ? text;
  final bool isDone;

  TodoWidget({this.text,required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isDone ? null : Border.all(color:Color(0xFF868290),width: 1.0),
                
              ),
              child: Image(image: AssetImage('assets/images/check_icon.png')),
              ),
          ),
            Text( text ?? 'Create Todo',style: TextStyle(
              fontWeight:isDone ? FontWeight.bold : null ,
              color: isDone ? Color(0xFF211551) : Color(0xFF868290),
              decoration: isDone ? TextDecoration.lineThrough : null 
              ),)
        ],
      ),
    );
  }
}