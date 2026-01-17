/// Enum for different ways to sort posts
enum PostSortType {
  /// Sort by post ID in ascending order (default)
  idAscending('ID (A-Z)', 'id_asc'),

  /// Sort by post ID in descending order
  idDescending('ID (Z-A)', 'id_desc'),

  /// Sort by title alphabetically (A-Z)
  titleAscending('Title (A-Z)', 'title_asc'),

  /// Sort by title reverse alphabetically (Z-A)
  titleDescending('Title (Z-A)', 'title_desc'),

  /// Sort by user ID in ascending order
  userIdAscending('User ID (Low to High)', 'user_id_asc'),

  /// Sort by user ID in descending order
  userIdDescending('User ID (High to Low)', 'user_id_desc');

  /// Creates a [PostSortType] with display name and code
  const PostSortType(this.displayName, this.code);

  /// Human-readable name for the sort type
  final String displayName;

  /// Code identifier for the sort type
  final String code;

  /// Get sort type from code string
  static PostSortType fromCode(String code) {
    try {
      return PostSortType.values.firstWhere((type) => type.code == code);
    } catch (e) {
      return PostSortType.idAscending; // Default to ID ascending
    }
  }
}
