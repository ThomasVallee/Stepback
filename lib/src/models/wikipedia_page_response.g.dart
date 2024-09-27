// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wikipedia_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WikipediaPageResponse _$WikipediaPageResponseFromJson(
        Map<String, dynamic> json) =>
    WikipediaPageResponse(
      query: Query.fromJson(json['query'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WikipediaPageResponseToJson(
        WikipediaPageResponse instance) =>
    <String, dynamic>{
      'query': instance.query,
    };

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      pages: (json['pages'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Page.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'pages': instance.pages,
    };

Page _$PageFromJson(Map<String, dynamic> json) => Page(
      pageid: (json['pageid'] as num).toInt(),
      title: json['title'] as String,
      extract: json['extract'] as String,
      thumbnail: json['thumbnail'] == null
          ? null
          : Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'pageid': instance.pageid,
      'title': instance.title,
      'extract': instance.extract,
      'thumbnail': instance.thumbnail,
    };

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => Thumbnail(
      source: json['source'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
      'source': instance.source,
      'width': instance.width,
      'height': instance.height,
    };
