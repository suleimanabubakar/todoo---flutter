import 'package:flutter/material.dart';
import 'package:todoo/database_helper.dart';
import 'package:todoo/screens/Taskpage.dart';
import 'package:todoo/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
    
        child: Container(
            width: double.infinity, 
            color: Color(0xFFF6F6F6),
            padding: EdgeInsets.symmetric(horizontal: 24.0), 
            child: Stack(
            children: [
              
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 14.0,top:32.0),
                    child: Image(image: AssetImage('assets/images/logo.png'))),

                    Expanded(child: FutureBuilder(
                      initialData: [],
                      future:_dbHelper.getTasks(),
                      builder: (context,AsyncSnapshot snapshot){
                        return ListView.builder(
                          itemCount:  snapshot.data.length,
                          itemBuilder: (context,index){
                            return GestureDetector(onTap:(){
                              // print('wow');
                              Navigator.push(context,  MaterialPageRoute(builder: (context)=>TaskPage(task: snapshot.data[index])
                              )                           
                            ).then((value) => setState((){}));
                            }
                            
                            ,child: TaskCard(title: snapshot.data[index].title,description: snapshot.data[index].description,));
                          },
                        );
                      }
                    ))
                
                
    
                ],),
                
                Positioned(
                  bottom: 15.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskPage(task:null))).then((value) => setState((){}));
                    },
                    child: Container(                 
                      height: 60.0,
                      width: 60.0,
                      child: Image(image: AssetImage('assets/images/add_icon.png')),
                      decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF7349FE),Color(0xFF643FDB)],begin:Alignment(0.0,-1.0),end:Alignment(0.0,1.0)),                      
                      borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ),
                
                ]),
        ),
      ),
    );
  }
}