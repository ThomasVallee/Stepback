// lib/blocs/ai_reimagine_state.dart

part of 'ai_reimagine_cubit.dart';

abstract class AIReimagineState {
  const AIReimagineState();
}

class AIReimagineInitial extends AIReimagineState {}

class AIReimagineYearSelected extends AIReimagineState {
  final int year;

  const AIReimagineYearSelected({required this.year});
}

class AIReimagineCapturing extends AIReimagineState {}

class AIReimagineImageCaptured extends AIReimagineState {}

class AIReimagineTransforming extends AIReimagineState {}

class AIReimagineTransformed extends AIReimagineState {
  final String imageUrl;

  const AIReimagineTransformed({required this.imageUrl});
}

class AIReimagineError extends AIReimagineState {
  final String message;

  const AIReimagineError({required this.message});
}
