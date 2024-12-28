// To parse this JSON data, do
//
//     final moviesResponseData = moviesResponseDataFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/movie.dart';

MoviesResponseData moviesResponseDataFromJson(String str) =>
    MoviesResponseData.fromJson(json.decode(str));

String moviesResponseDataToJson(MoviesResponseData data) =>
    json.encode(data.toJson());

class MoviesResponseData {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MoviesResponseData({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponseData.fromJson(Map<String, dynamic> json) =>
      MoviesResponseData(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result extends Movie {
  Result({
    backdropPath,
    id,
    title,
    originalTitle,
    overview,
    posterPath,
    mediaType,
    adult,
    originalLanguage,
    genreIds,
    popularity,
    releaseDate,
    video,
    voteAverage,
    voteCount,
  }) : super(
            backdropPath: backdropPath,
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            mediaType: mediaType,
            adult: adult,
            originalLanguage: originalLanguage,
            genreIds: genreIds,
            popularity: popularity,
            releaseDate: releaseDate,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount);

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        title: json["title"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        mediaType: json["media_type"],
        adult: json["adult"],
        originalLanguage: json["original_language"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        popularity: json["popularity"]?.toDouble(),
        releaseDate: DateTime.parse(json["release_date"]),
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaType,
        "adult": adult,
        "original_language": originalLanguage,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
