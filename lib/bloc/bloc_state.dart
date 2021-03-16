
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];

}

class TodoInitial extends TodoState {}

class TodoLoadSuccess extends TodoState {

  final String uid;
  const TodoLoadSuccess({@required this.uid}) : assert(uid != null);

  @override
  List<Object> get props => [uid];

}
class ToDoLoadInProgress extends TodoState {}

class TodoLoadFailure extends TodoState {}
