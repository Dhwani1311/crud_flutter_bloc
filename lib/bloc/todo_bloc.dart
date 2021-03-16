
export 'bloc_state.dart';
export 'todo_event.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud_bloc/bloc/bloc_state.dart';
import 'package:flutter_crud_bloc/bloc/todo_event.dart';
import 'package:bloc/bloc.dart';

class TodoBloc extends Cubit<TodoState> {

  TodoBloc() : super(TodoInitial());
  String uid = 'As6ewnk2aRbxs';
  String title  = '';
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // final User user = _auth.currentUser;
  //
  // final uid = user.uid;

  // final FirebaseAuth auth = FirebaseAuth.instance;
  //
  // final User user = auth.currentUser;
  // final uid = user.uid;
  // @override
  // Stream<TodoState> mapEventToState(TodoEvent event) async* {
  //   if(event is TodoInitial){
  //     emit(ToDoLoadInProgress());
  //    try{
  //      final data =  await getItem();
  //      if(data.data() != null) {
  //        emit(TodoLoadSuccess(uid: uid));
  //      }else{
  //        emit(TodoLoadFailure());
  //      }
  //    }catch(e){
  //      emit(TodoLoadFailure());
  //    }
  //   }
  //   // if (event is  TodoRequested) {
  //   //   yield ToDoLoadInProgress();
  //   //   try {
  //   //     yield TodoLoadSuccess(uid: uid);
  //   //   } catch (_) {
  //   //     yield TodoLoadFailure();
  //   //   }
  //   // }
  // }

  Future<void> getItem(event) async{

    if(event is TodoInitial){
      emit(ToDoLoadInProgress());
      try{
        DocumentReference documentReference = FirebaseFirestore.instance.collection("Notes").doc(uid);
       final data = await documentReference.get();
       print(data.data());
        if(data.data() != null) {
          emit(TodoLoadSuccess(uid: uid));
        }else{
          emit(TodoLoadFailure());
        }
      }catch(e){
        emit(TodoLoadFailure());
      }
    }
  }

  createItems() {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Notes").doc(uid);
    Map<String, String> items = {"title": title,"uid":uid};
    documentReference.set(items).whenComplete(() => print('Item created'));
  }

  deleteItems(DocumentSnapshot item) {
    FirebaseFirestore.instance.collection('Notes').doc(item.id).delete().then((value) => print('Item Deleted'));
  }

  editItems(DocumentSnapshot documentSnapshot) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Notes").doc(documentSnapshot.id);
    Map<String, String> items = {"title": title,"uid":uid};
    await documentReference.update(
        items).then((documentReference) {
      // Navigator.pop(context);
      print("Note Edited");
    }).catchError((e) {
      print(e);
    });
  }

  // @override
  // Stream<TodoState> mapEventToState(TodoEvent event) {
  //   throw UnimplementedError();
  // }

}
