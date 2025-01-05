/// sanity perspective enum
enum Perspective {
  /// get all published documents
  published,

  /// get all published and unpublished documents
  previewDrafts,

  /// get all published, unpublished, and meta information
  raw,
}

/// Sanity API configuration object
class SanityConfig {
  /// sanity projectId: asdf124
  final String projectId;

  /// sanity dataset: production
  final String dataset;

  /// sanity perspective(defaults to Perspective.published)
  final Perspective perspective;

  /// API authenticated token
  final String? token;

  /// sets the fetch host to be apicdn.sanity.io if true
  /// otherwise it sets it to api.sanity.io if false
  final bool useCdn;

  /// yyyy-mm-dd api version number
  final String apiVersion;

  /// sets a tag to all queries
  final String? tag;

  /// latest sanity http API version
  static final String defaultApiVersion = (() {
    final today = DateTime.now();
    final parts = [
      today.year.toString(),
      today.month.toString().padLeft(2, '0'),
      today.day.toString().padLeft(2, '0')
    ].join('-');

    return 'v$parts';
  })();

  /// Sanity config constructor
  SanityConfig({
    required this.projectId,
    required this.dataset,
    this.token,
    Perspective? perspective = Perspective.published,
    bool? useCdn = true,
    String? apiVersion,
    this.tag,
  })  : useCdn = useCdn ?? true,
        apiVersion = apiVersion ?? defaultApiVersion,
        perspective = perspective ?? Perspective.published {
    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}
