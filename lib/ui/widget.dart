
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_bloc/bloc/todo_bloc.dart';

class MyHomePage extends StatefulWidget {

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<MyHomePage> {
  //Completer<void> _refreshCompleter;

  _NotesState();
  String uid;

  @override
  void initState() {
   // _refreshCompleter = Completer<void>();
    getItem();
    super.initState();
  }

  Future getItem() async{
   await  context.read<TodoBloc>().getItem(TodoInitial());
  }

  @override
  Widget build(BuildContext context) {

    // ignore: close_sinks
    final todos = TodoBloc();

    return new Scaffold(
      appBar: new AppBar(
        title: Center(child: Text("Crud Flutter_bloc")),
      ),
      body: BlocBuilder<TodoBloc,TodoState>(
        // ignore: missing_return
        builder: (context,state) {
          if (state is TodoInitial) {
            return Center(child: Text('No Note found'));
          }
          if (state is ToDoLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TodoLoadSuccess) {
            // ignore: close_sinks
            //final TodoBloc todos = TodoBloc(state.uid);

            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
              builder: (context, snapshots) {
                // if (snapshots.data == null)
                //   return Center(
                //       child: Text(
                //         "No Notes", style: TextStyle(color: Colors.grey),));

                return ListView.builder(
                    itemCount: snapshots.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshots.data
                          .docs[index];

                      return Dismissible(
                        onDismissed: (direction) {
                          //context.read<TodoBloc>().deleteItems(documentSnapshot);
                          todos.deleteItems(documentSnapshot);
                        },
                        key: Key(documentSnapshot["title"]),
                        child: GestureDetector(
                          child: Card(
                            margin: EdgeInsets.all(8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              title: Text(documentSnapshot["title"],
                                style: TextStyle(fontSize: 22.0),),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                onPressed: () {
                                  //context.read<TodoBloc>().deleteItems(documentSnapshot);
                                  todos.deleteItems(documentSnapshot);
                                  final snackBar = SnackBar(
                                    content: Text('Note Deleted'),);
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    title: Text("Edit Note", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),),
                                    content: TextField(
                                      onChanged: (String value) {
                                        todos.title = value;
                                        //todos.uid = value;
                                      },
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                         // context.read<TodoBloc>().editItems(documentSnapshot);
                                          todos.editItems(documentSnapshot);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Save", style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel", style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        ),)
                                    ],
                                  );
                                });
                          },

                        ),
                      );
                    });
              },
            );
          }
          if (state is TodoLoadFailure) {
            return Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.red),
            );
          }
        },
    ),

      floatingActionButton: FloatingActionButton (
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  title: Text("Add New Note",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  content: TextField(
                    onChanged: (String value) {
                      todos.title = value;
                      //todos.uid = value;

                    },
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        //context.watch<TodoBloc>().createItems();
                        todos.createItems();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add" ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    FlatButton(
                      onPressed:(){
                        Navigator.of(context).pop();
                      },
                      child:  Text("Cancel",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),)
                  ],
                );
              });
        },
        child: Icon(Icons.add, color: Colors.black),
      ),

    );
  }
}
