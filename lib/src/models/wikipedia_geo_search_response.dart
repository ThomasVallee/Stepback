// lib/models/wikipedia_geosearch_response.dart

import 'package:json_annotation/json_annotation.dart';

part 'wikipedia_geo_search_response.g.dart';

@JsonSerializable()
class WikipediaGeoSearchResponse {
  final Query query;

  WikipediaGeoSearchResponse({required this.query});

  factory WikipediaGeoSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$WikipediaGeoSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WikipediaGeoSearchResponseToJson(this);
}

@JsonSerializable()
class Query {
  final List<GeoSearchResult> geosearch;

  Query({required this.geosearch});

  factory Query.fromJson(Map<String, dynamic> json) =>
      _$QueryFromJson(json);

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

@JsonSerializable()
class GeoSearchResult {
  final int pageid;
  final String title;
  final double lat;
  final double lon;
  final double dist;
  final String? primary; // Might be null

  GeoSearchResult({
    required this.pageid,
    required this.title,
    required this.lat,
    required this.lon,
    required this.dist,
    this.primary,
  });

  factory GeoSearchResult.fromJson(Map<String, dynamic> json) =>
      _$GeoSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$GeoSearchResultToJson(this);
}
