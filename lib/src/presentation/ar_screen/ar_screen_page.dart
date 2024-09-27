// lib/screens/ar_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepback/src/presentation/ar_screen/ar_screen_cubit.dart';
import 'package:stepback/src/presentation/historical_sites/historical_sites_cubit.dart';
import 'package:stepback/src/presentation/historical_sites/nearby_sites_widget.dart';
import 'package:stepback/src/presentation/location_info_widget/location_info_cubit.dart';
import 'package:stepback/src/presentation/location_info_widget/location_info_widget.dart';
import 'package:stepback/src/services/compass_logic.dart';
import 'package:stepback/src/widgets/ar_view_widget.dart';
import 'package:stepback/src/widgets/compass_arrow_widget.dart';
import 'package:stepback/src/widgets/historical_site_details.dart';

import '../../models/wikipedia_geo_search_response.dart';


class ARScreenView extends StatefulWidget {
  static const String routeName = '/ar';
  const ARScreenView({Key? key}) : super(key: key);

  @override
  State<ARScreenView> createState() => _ARScreenViewState();
}

class _ARScreenViewState extends State<ARScreenView> {
  late ARScreenCubit _arScreenCubit;
  late LocationInfoCubit _locationInfoCubit;
  late HistoricalSitesCubit _historicalSitesCubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _arScreenCubit = BlocProvider.of<ARScreenCubit>(context);
      _locationInfoCubit = BlocProvider.of<LocationInfoCubit>(context);
      _historicalSitesCubit = BlocProvider.of<HistoricalSitesCubit>(context);
      
      _arScreenCubit.initializeAR();
      _locationInfoCubit.loadLocationInfo();

      _isInitialized = true;
    }
  }
  

  @override
  void dispose() {
    // stop the ar session
    _historicalSitesCubit.reset();
    _arScreenCubit.disposeAR();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to rebuild the UI based on the state
    return BlocBuilder<ARScreenCubit, ARScreenState>(
      builder: (context, state) {
        if (state is ARScreenLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ARScreenLoaded) {
          return Scaffold(
            body: BlocListener<LocationInfoCubit, LocationInfoState>(
              listener: (context, state) {
               if (state is LocationInfoLoaded) {
                  _historicalSitesCubit.fetchHistoricalSites(state.latitude, state.longitude);                
               }
              },
              child: Stack(
                children: [
                  const ARViewWidget(),
                  BlocBuilder<LocationInfoCubit, LocationInfoState>(
                    builder: (context, state) {
                      if (state is LocationInfoLoaded) {                        
                        return LocationInfoWidget(
                          title: state.title,
                          description: state.description,
                        );
                      } else if (state is LocationInfoLoading) {
                        // Optionally show a loading indicator
                        return const Positioned(
                          bottom: 20.0,
                          left: 20.0,
                          right: 20.0,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is LocationInfoError) {
                        // Handle error state
                        return Positioned(
                          bottom: 20.0,
                          left: 20.0,
                          right: 20.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.red.withOpacity(0.7),
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return Container(); // Return empty container if state is initial
                      }
                    },
                  ),
                  BlocBuilder<HistoricalSitesCubit, HistoricalSitesState>(
                    builder: (context, state) {
                      if (state is HistoricalSitesLoaded) {
                        return NearbySitesWidget(
                          sites: state.sites,
                          selectedSite: state.selectedSite ?? GeoSearchResult(pageid: 0, title: '', lat: 0.0, lon: 0.0, dist: 0.0),
                           );
                      } else if (state is HistoricalSitesLoading) {
                        return const Positioned(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is HistoricalSitesError) {
                        return Positioned(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.red.withOpacity(0.7),
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                          // Compass Arrow Widget
                  BlocBuilder<HistoricalSitesCubit, HistoricalSitesState>(
                    builder: (context, state) {
                      if (state is HistoricalSitesLoaded && state.selectedSite != null) {
                        final selectedSite = state.selectedSite!;
                        // Get user's location
                        final locationState =
                            context.read<LocationInfoCubit>().state;
                        if (locationState is LocationInfoLoaded) {
                          double userLatitude = locationState.latitude;
                          double userLongitude = locationState.longitude;

                          // Calculate bearing
                          double bearingToSite = calculateBearing(
                            userLatitude,
                            userLongitude,
                            selectedSite.lat,
                            selectedSite.lon,
                          );

                          return CompassArrowWidget(bearingToSite: bearingToSite);
                        }
                      }
                      return Container();
                    },
                  ),
                  BlocBuilder<HistoricalSitesCubit, HistoricalSitesState>(
                    builder: (context, state) {
                      if (state is HistoricalSitesLoaded &&
                          state.selectedPage != null) {
                        return Positioned(
                          top: 20.0,
                          right: 5.0,
                          width: 200.0,
                          height: 250.0,
                          child: SiteDetailsOverlay(sitePage: state.selectedPage!),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ), 

                  // AI Reimagine Page Screenshot button
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: FloatingActionButton(
                      onPressed: () async {
                        // ensure we close the AR session
                        _historicalSitesCubit.reset();
                        _arScreenCubit.disposeAR();
                        await Future.delayed(const Duration(seconds: 1));


                       Navigator.pushNamed(context, '/ai-reimagine');
                      },
                      child: const Icon(Icons.auto_awesome),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ARScreenError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          // Initial State
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
