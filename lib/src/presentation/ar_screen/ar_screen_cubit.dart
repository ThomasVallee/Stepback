// lib/presentation/ar_screen/ar_screen_cubit.dart

import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

part 'ar_screen_state.dart';

class ARScreenCubit extends Cubit<ARScreenState> {
  ARSessionManager? _arSessionManager;
  ARObjectManager? _arObjectManager;
  bool _isDisposed = false;

  ARScreenCubit() : super(ARScreenInitial());

  void initializeAR() {
    emit(ARScreenLoading());
    // Initialization logic
    // This should set up _arSessionManager and _arObjectManager
    // For example:
    // _arSessionManager = ...;
    // _arObjectManager = ...;
    // After initialization:
    emit(ARScreenLoaded());
  }

  void disposeAR() {
    if (_isDisposed) return;
    _isDisposed = true;
    _arSessionManager?.dispose();    
    emit(ARScreenInitial());
  }

  @override
  Future<void> close() {
    disposeAR();
    return super.close();
  }
}
