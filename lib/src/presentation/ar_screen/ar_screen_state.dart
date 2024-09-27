// lib/blocs/ar_screen_state.dart
 part of 'ar_screen_cubit.dart';

abstract class ARScreenState {}

class ARScreenInitial extends ARScreenState {}

class ARScreenLoading extends ARScreenState {}

class ARScreenLoaded extends ARScreenState {}

class ARScreenError extends ARScreenState {
  final String message;

  ARScreenError(this.message);
}
