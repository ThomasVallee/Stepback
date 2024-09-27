part of 'historical_sites_cubit.dart';

abstract class HistoricalSitesState {
  const HistoricalSitesState();
}

class HistoricalSitesInitial extends HistoricalSitesState {}

class HistoricalSitesLoading extends HistoricalSitesState {}

class HistoricalSitesLoaded extends HistoricalSitesState {
  final List<GeoSearchResult> sites;
  final GeoSearchResult? selectedSite; // Added this field
  final Page? selectedPage; // Added this field

  const HistoricalSitesLoaded({this.selectedPage, required this.sites, this.selectedSite});
}

class HistoricalSitesError extends HistoricalSitesState {
  final String message;

  const HistoricalSitesError(this.message);
}
