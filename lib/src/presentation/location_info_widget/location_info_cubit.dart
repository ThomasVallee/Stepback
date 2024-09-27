// lib/blocs/location_info_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:location/location.dart' as Location;
import 'package:geocoding/geocoding.dart';

part 'location_info_state.dart';

class LocationInfoCubit extends Cubit<LocationInfoState> {
  LocationInfoCubit() : super(LocationInfoInitial());

  void loadLocationInfo() async {
    emit(LocationInfoLoading());

    try {
      Location.Location location = Location.Location();

      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          emit(LocationInfoError('Location services are disabled.'));
          return;
        }
      }

      // Check for location permissions
      Location.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == Location.PermissionStatus.denied ||
          permissionGranted == Location.PermissionStatus.deniedForever) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != Location.PermissionStatus.granted) {
          emit(LocationInfoError('Location permissions are denied.'));
          return;
        }
      }

      // Get the user's current location
      Location.LocationData locationData = await location.getLocation();

      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;

      if (latitude != null && longitude != null) {
        // Perform reverse geocoding to get address information
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude,
          longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          String addressTitle = _buildAddressTitle(place);
          String addressDescription = _buildAddressDescription(
            latitude,
            longitude,
          );

          emit(LocationInfoLoaded(
            title: addressTitle,
            description: addressDescription,
            latitude: latitude,
            longitude: longitude,
          ));
        } else {
          emit(LocationInfoError('No address available for this location.'));
        }        


      } else {
        emit(LocationInfoError('Failed to get location coordinates.'));
      }
    } catch (e) {
      emit(LocationInfoError('Failed to load location info.'));
    }
  }

  String _buildAddressTitle(Placemark place) {
    List<String> addressComponents = [];

    if (place.locality != null && place.locality!.isNotEmpty) {
      addressComponents.add(place.locality!); // City/Town
    }

    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressComponents.add(place.administrativeArea!); // State
    }

    if (place.country != null && place.country!.isNotEmpty) {
      addressComponents.add(place.country!); // Country
    }

    return addressComponents.join(', ');
  }

  String _buildAddressDescription(double latitude, double longitude) {
    return 'Latitude: $latitude, Longitude: $longitude';
  }
}
