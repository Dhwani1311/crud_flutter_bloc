import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_bloc/bloc_observer.dart';
import 'package:flutter_crud_bloc/ui/widget.dart';

import 'bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //String uid;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter crud',
      home: BlocProvider(
        create: (_) =>
            TodoBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

