import 'package:flutter_bloc/flutter_bloc.dart';

/// Business Logic Component ExampleBLoC
class ExampleBLoC extends Bloc<ExampleEvent, ExampleState> {
  ExampleBLoC() : super(ExampleState()) {
    on<ExampleEvent>(
      (event, emit) => ExampleEvent(),
    );
  }
}

class ExampleEvent {}

class ExampleState {}
