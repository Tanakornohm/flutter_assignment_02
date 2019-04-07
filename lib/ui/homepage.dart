import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/storage/todo.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoState();
  }
  
}

class TodoState extends State<Homepage>{
  TodoProvider provider = TodoProvider();
  int tabIndex = 0;
  int countTask = 0;
  int countComp = 0;
  List<Todo> taskTodo;
  List<Todo> compTodo;

  void getTaskTodo() async{
    await provider.open('todo.db');
    provider.getTodoAllTask().then((taskTodo){
      setState(() {
        this.taskTodo = taskTodo;
        this.countTask = taskTodo.length;
      });
    });
    provider.getTodoAllComp().then((compTodo){
      setState(() {
        this.compTodo = compTodo;
        this.countComp = compTodo.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getTaskTodo();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
            tabIndex == 0?
            Icons.add :
            Icons.delete),
            onPressed: () async {
              tabIndex == 0?
              Navigator.pushNamed(context, '/adding')
              : await provider.deleteAllCompTodo();
              setState(() {
                
              });
            },
          ),
        ],
      ),
      body: Center(
        child: tabIndex == 0?
        countTask > 0?
        ListView.builder(
          itemCount: countTask,
          itemBuilder: (context, int index){
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(this.taskTodo[index].title),
                  trailing: Checkbox(
                    onChanged: (bool boolean) {
                      setState(() {
                        taskTodo[index].done = boolean;
                      });
                      provider.update(taskTodo[index]);
                    },
                    value: taskTodo[index].done,
                  ),
                ),
              ],
            );
          },
        ):Text('No data found..')
        : countComp > 0 ?
        ListView.builder(
          itemCount: countComp,
          itemBuilder: (context, int index){
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    this.compTodo[index].title,
                  ),
                  trailing: Checkbox(
                    onChanged: (bool boolean){
                      setState(() {
                        compTodo[index].done = boolean;
                      });
                      provider.update(compTodo[index]);
                    },
                    value: compTodo[index].done,
                  ),
                )
              ],
            );
          },
        )
        :Text("No data found..")
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text("Task")),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed')
          )
        ],
        onTap: (int i){
          setState(() {
            tabIndex = i;
          });
        },

      ),
    );
  }
  
}