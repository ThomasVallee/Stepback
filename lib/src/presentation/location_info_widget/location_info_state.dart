// lib/blocs/location_info_state.dart

part of 'location_info_cubit.dart';

abstract class LocationInfoState {
  const LocationInfoState();

}

class LocationInfoInitial extends LocationInfoState {}

class LocationInfoLoading extends LocationInfoState {}

class LocationInfoLoaded extends LocationInfoState {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  const LocationInfoLoaded({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

}

class LocationInfoError extends LocationInfoState {
  final String message;

  const LocationInfoError(this.message);
}
