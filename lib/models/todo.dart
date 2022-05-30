class Todo {

  final int? id ;
  final String   title;
  final int? isDone;
  final int? taskId;

  Todo({this.id ,required this.title,this.isDone,this.taskId});


  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'title':title,
      'taskId':taskId,
      'isDone':isDone,
    };
  }


}