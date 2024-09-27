// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wikipedia_geo_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WikipediaGeoSearchResponse _$WikipediaGeoSearchResponseFromJson(
        Map<String, dynamic> json) =>
    WikipediaGeoSearchResponse(
      query: Query.fromJson(json['query'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WikipediaGeoSearchResponseToJson(
        WikipediaGeoSearchResponse instance) =>
    <String, dynamic>{
      'query': instance.query,
    };

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      geosearch: (json['geosearch'] as List<dynamic>)
          .map((e) => GeoSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'geosearch': instance.geosearch,
    };

GeoSearchResult _$GeoSearchResultFromJson(Map<String, dynamic> json) =>
    GeoSearchResult(
      pageid: (json['pageid'] as num).toInt(),
      title: json['title'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      dist: (json['dist'] as num).toDouble(),
      primary: json['primary'] as String?,
    );

Map<String, dynamic> _$GeoSearchResultToJson(GeoSearchResult instance) =>
    <String, dynamic>{
      'pageid': instance.pageid,
      'title': instance.title,
      'lat': instance.lat,
      'lon': instance.lon,
      'dist': instance.dist,
      'primary': instance.primary,
    };
