class SearchFilters {
  final List<String> genres;
  final List<String> wardrobes;

  SearchFilters({
    List<String>? genres,
    List<String>? wardrobes,
  })  : genres = genres ?? [],
        wardrobes = wardrobes ?? [];

  bool get hasGenreFilter => genres.isNotEmpty;
  bool get hasWardrobeFilter => wardrobes.isNotEmpty;
  bool get hasAnyFilter => hasGenreFilter || hasWardrobeFilter;

  SearchFilters copyWith({
    List<String>? genres,
    List<String>? wardrobes,
  }) {
    return SearchFilters(
      genres: genres ?? this.genres,
      wardrobes: wardrobes ?? this.wardrobes,
    );
  }

  @override
  String toString() {
    return 'SearchFilters(genres: $genres, wardrobes: $wardrobes)';
  }
}