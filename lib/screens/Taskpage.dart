import 'package:flutter/material.dart';
import 'package:todoo/database_helper.dart';
import 'package:todoo/models/task.dart';
import 'package:todoo/models/todo.dart';
import 'package:todoo/widgets.dart';

class TaskPage extends StatefulWidget {

  final Task ? task;
  
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  String ? _taskTitle;
  String ? _taskDescription;
  int _taskId = 0;
  String _blankTodo = '';

  FocusNode ? _titleFocus;
  FocusNode ? _descriptionFocus;
  FocusNode ? _todoFocus;


  // visibility
  bool _contentVisibility = false;

  DatabaseHelper _dbHelper = DatabaseHelper();


  @override
  void initState() {
    if(widget.task != null){
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;
      _taskId = widget.task!.id!;
      _contentVisibility = true;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }
  

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(

            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 20.0),
                    child: Row(
                      
                      children: [
                      InkWell(
                        onTap: (){ Navigator.pop(context);},
                        child: Padding(
                          padding: const EdgeInsets.only(right:20.0),
                          child: Image(image: AssetImage('assets/images/back_arrow_icon.png'),),
                        ),
                      ),
                      Expanded(child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                         
                          // checking if a new task or past

                          if (widget.task == null) {                          
                             if (value != ''){
                          DatabaseHelper _dbHelper = DatabaseHelper();
                          Task _newTask = Task(
                            title:value,
                          );
                          _taskId =  await _dbHelper.insertTask(_newTask);
                        setState(() {
                           _taskTitle = value;
                           _contentVisibility = true;
                         });
                          print('Task Added');

                          }
                          }else{
                            if(value != ''){
                              if(_taskId != 0){
                                await _dbHelper.updateTitle(_taskId, value);
                              }
                            }
                          }

                          // submitting the focus to description
                          _descriptionFocus?.requestFocus();
               

                        },                        
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0
                        ),
                        controller: TextEditingController(text: _taskTitle),
                        decoration: InputDecoration(
                          hintText: 'Enter Title',
                          border: InputBorder.none
                        ),
                      ))
                    ],),
                  ),

                // adding description block 
                  Visibility(
                    visible:  _contentVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        onSubmitted: (value) async {
                          if(value != ''){
                           await _dbHelper.updateDescription(_taskId, value);
                          }
                        setState(() {
                          _taskDescription = value;
                        });
                          _todoFocus?.requestFocus();
                        },
                        focusNode: _descriptionFocus,
                        controller: TextEditingController(text: _taskDescription),
                        decoration: InputDecoration(border: InputBorder.none,hintText:'Enter Description',contentPadding: EdgeInsets.symmetric(horizontal: 20.0,)),
                        style:TextStyle(fontSize: 16.0,color:Color(0xFF868290))
                      ),
                    ),
                  ),
                  
               

                  Visibility(
                    visible: _contentVisibility,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                      builder: (context,AsyncSnapshot snapshot){
                         return Expanded(
                           child: ListView.builder(
                              itemCount:  snapshot.data.length,
                              itemBuilder: (context,index){
                                return GestureDetector(onTap:() async {    
                                      var _isDoneVal = 0;
                                      if(snapshot.data[index].isDone == 0){
                                          _isDoneVal = 1;
                                      }else{
                                        _isDoneVal = 0;
                                      }
                                      await _dbHelper.updateTodo(snapshot.data[index].id, _isDoneVal);
                                      setState(() {
                                      });
                                }
                                
                                ,child: TodoWidget(text: snapshot.data[index].title,isDone: snapshot.data[index].isDone == 0 ? false : true,));
                              },
                            ),
                         );
                      },
                    ),
                  ),

                  // adding todo block
                  Visibility(
                    visible: _contentVisibility,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 25.0),
                      child: Column(
                        children: [
                          Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20.0),
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(border: Border.all(color: Color(0xFF868290)),borderRadius: BorderRadius.circular(90)),
                            ),
                            Expanded(child:TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController(text: _blankTodo),
                              onSubmitted: (value) async {
                                if(value != ''){
                                  if(_taskId != null) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Todo _newTodo = Todo(title: value,taskId: _taskId ,isDone: 0);
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus?.requestFocus();
                                  }
                                  
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add a Todo'
                              ),
                            ))
                          ],
                          )
                        ],
                      ),
                    ),
                  ),
              
                  
                  ],
                  ),
            
             Visibility(
               visible: _contentVisibility,
               child: Positioned(
                    bottom: 15.0,
                    right: 20.0,
                    child: GestureDetector(
                      onTap: (){
                        // delete query
                        _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                        
                      },
                      child: Container(                 
                        height: 60.0,
                        width: 60.0,
                        child: Image(image: AssetImage('assets/images/delete_icon.png')),
                        decoration: BoxDecoration(color: Color(0xFFFE3577),borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
             ),

              ],
            )
        ),
      ),
    );
  }
}