// lib/models/wikipedia_page_response.dart

import 'package:json_annotation/json_annotation.dart';

part 'wikipedia_page_response.g.dart';

@JsonSerializable()
class WikipediaPageResponse {
  final Query query;

  WikipediaPageResponse({required this.query});

  factory WikipediaPageResponse.fromJson(Map<String, dynamic> json) =>
      _$WikipediaPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WikipediaPageResponseToJson(this);
}

@JsonSerializable()
class Query {
  final Map<String, Page> pages;

  Query({required this.pages});

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

@JsonSerializable()
class Page {
  final int pageid;
  final String title;
  final String extract;
  final Thumbnail? thumbnail;

  Page({
    required this.pageid,
    required this.title,
    required this.extract,
    this.thumbnail,
  });

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}

@JsonSerializable()
class Thumbnail {
  final String source;
  final int width;
  final int height;

  Thumbnail({
    required this.source,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}
