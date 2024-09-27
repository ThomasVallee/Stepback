import 'package:bloc/bloc.dart';
import 'package:stepback/src/models/wikipedia_geo_search_response.dart';
import 'package:stepback/src/models/wikipedia_page_response.dart';
import 'package:stepback/src/resources/network/rest_api.dart';

part 'historical_sites_state.dart';

class HistoricalSitesCubit extends Cubit<HistoricalSitesState> {
  final RestClient apiClient;

  HistoricalSitesCubit({required this.apiClient})
      : super(HistoricalSitesInitial());

  Future<void> fetchHistoricalSites(double latitude, double longitude) async {
    emit(HistoricalSitesLoading());

    try {
      String gscoord = '$latitude|$longitude';
      WikipediaGeoSearchResponse response = await apiClient.getNearbyHistoricalSites(
        'query',
        'geosearch',
        gscoord,
        5000, // Adjust as needed
        10, // Adjust as needed
        'json',
      );

      emit(HistoricalSitesLoaded(sites: response.query.geosearch));
      print('Loaded ${response.query.geosearch.length} historical sites.');
    } catch (e) {
      emit(HistoricalSitesError('Failed to load historical sites.'));
    }
  }

Future<void> fetchSiteDetails(GeoSearchResult site) async {
  if (state is HistoricalSitesLoaded) {
    // Store the previous state
    final previousState = state as HistoricalSitesLoaded;

    // Emit loading state
    emit(HistoricalSitesLoading());

    try {
      // Fetch page content
      WikipediaPageResponse pageResponse = await apiClient.getPageContent(
        pageids: site.pageid,
      );

      // Get the page details
      Page sitePage = pageResponse.query.pages.values.first;

      // Update the state with the selected site and its details
      emit(HistoricalSitesLoaded(
        sites: previousState.sites,
        selectedSite: site,
        selectedPage: sitePage,
      ));
    } catch (e) {
      // Handle error
      emit(HistoricalSitesError('Failed to load site details.'));

      // Re-emit the previous loaded state without the selected site details
      emit(HistoricalSitesLoaded(
        sites: previousState.sites,
      ));
    }
  }
}

  void selectSite(GeoSearchResult site) {
    if (state is HistoricalSitesLoaded) {
      final loadedState = state as HistoricalSitesLoaded;
      emit(HistoricalSitesLoaded(
        sites: loadedState.sites,
        selectedSite: site,
      ));
    }
  }

  void clearSelectedSite() {
    if (state is HistoricalSitesLoaded) {
      final loadedState = state as HistoricalSitesLoaded;
      emit(HistoricalSitesLoaded(
        sites: loadedState.sites,
        selectedSite: null,
        selectedPage: null,
      ));
    }
  }

  void reset() {
    emit(HistoricalSitesInitial());
  }
}
