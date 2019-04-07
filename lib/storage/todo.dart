import 'package:sqflite/sqflite.dart';


final String tableTodo = "todo";
final String columnId = "id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if(id != null) {
      map[columnId] = id;
    }
    return map;

    
  }

  Todo({this.id, this.title, this.done});

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;
  
  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async{
      await db.execute(
        '''create table $tableTodo (
          $columnId integer primary key autoincrement,
          $columnTitle text not null,
          $columnDone integer not null)
        '''
      );
    });
  }
  Future<Todo> insert(Todo todo) async{
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async{
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
        if (maps.length > 0) {
          return new Todo.fromMap(maps.first);
        }
        return null;
  }

  Future<int> delete(int id) async{
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Todo todo) async{
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future<List<Todo>> getTodoAllTask() async{
    var todo = await db.query(tableTodo, where: "$columnDone = 0");
    return todo.map((f) =>Todo.fromMap(f)).toList();
  }

  Future<List<Todo>> getTodoAllComp() async{
    var todo =await db.query(tableTodo, where: "$columnDone = 1");
    return todo.map((f) => Todo.fromMap(f)).toList();
  }

  Future deleteAllCompTodo() async{
    await db.delete(tableTodo, where: "$columnDone = 1");
  }
  Future close() async => db.close();
}