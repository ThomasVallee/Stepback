import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stepback/src/models/wikipedia_page_response.dart' hide Query, Page;

import '../../models/wikipedia_geo_search_response.dart' hide Query, GeoSearchResult;

part 'rest_api.g.dart';

@RestApi(baseUrl: "https://en.wikipedia.org")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/w/api.php')
  Future<WikipediaGeoSearchResponse> getNearbyHistoricalSites(
    @Query('action') String? action,
    @Query('list') String? list,
    @Query('gscoord') String? gscoord, // "latitude|longitude"
    @Query('gsradius') int? gsradius, // Radius in meters
    @Query('gslimit') int? gslimit,   // Max results
    @Query('format') String? format,
  );

    @GET("/w/api.php")
  Future<WikipediaPageResponse> getPageContent({
    @Query("action") String action = "query",
    @Query("prop") String prop = "extracts|pageimages",
    @Query("exintro") int exintro = 1,
    @Query("explaintext") int explaintext = 1,
    @Query("pageids") required int pageids,
    @Query("pithumbsize") int pithumbsize = 500,
    @Query("format") String format = "json",
  });
}

