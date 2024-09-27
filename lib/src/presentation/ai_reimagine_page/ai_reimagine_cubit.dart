// lib/blocs/ai_reimagine_cubit.dart

import 'package:image_picker/image_picker.dart';
import 'package:bloc/bloc.dart';
import 'dart:io';

import 'package:stepback/src/services/monster_api_service.dart';
part 'ai_reimagine_state.dart';

class AIReimagineCubit extends Cubit<AIReimagineState> {
  final MonsterApiService _monsterApiService = MonsterApiService();

  AIReimagineCubit() : super(AIReimagineInitial());

  void selectYear(int year) {
    emit(AIReimagineYearSelected(year: year));
  }

  File? capturedImage;

  Future<void> captureImage() async {
    emit(AIReimagineCapturing());
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        capturedImage = File(pickedFile.path);
        emit(AIReimagineImageCaptured());
      } else {
        emit(AIReimagineError(message: 'Image capture cancelled.'));
      }
    } catch (e) {
      emit(AIReimagineError(message: 'Failed to capture image.'));
    }
  }

  Future<void> transformImage() async {
    if (capturedImage == null) {
      emit(AIReimagineError(message: 'No image captured.'));
      return;
    }

    emit(AIReimagineTransforming());

    try {
      String transformedImageUrl = await _monsterApiService.transformImage(capturedImage!);
      emit(AIReimagineTransformed(imageUrl: transformedImageUrl));
    } catch (e) {
      emit(AIReimagineError(message: e.toString()));
    }
  }

  void reset() {
    capturedImage = null;
    emit(AIReimagineInitial());
  }
}
