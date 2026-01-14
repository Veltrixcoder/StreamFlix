
class MediaItem {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final bool isAdult;
  final String mediaType; // 'movie' or 'tv'

  MediaItem({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.isAdult,
    required this.mediaType,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Unknown',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      isAdult: json['adult'] ?? false,
      mediaType: json['media_type'] ?? 'movie', // Default to movie if not specified, but usually handling lists where it might be mixed
    );
  }

  String get fullPosterUrl => posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';
  String get fullBackdropUrl => backdropPath != null ? 'https://image.tmdb.org/t/p/original$backdropPath' : '';
}

class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
    );
  }
   String get fullProfileUrl => profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : '';
}
