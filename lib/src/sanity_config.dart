/// sanity static class getter for perspective
class Perspective {
  /// get all published documents
  static String get published => 'published';

  /// get all published and unpublished documents
  static String get previewDrafts => 'previewDrafts';

  /// get all published, unpublished, and meta information
  static String get raw => 'raw';
}

/// Sanity API configuration object
class SanityConfig {
  /// sanity projectId: asdf124
  final String projectId;

  /// sanity dataset: production
  final String dataset;

  /// sanity perspective(defaults to Perspective.published)
  final String perspective = Perspective.published;

  /// API authenticated token
  final String? token;

  /// sets the fetch host to be apicdn.sanity.io if true
  /// otherwise it sets it to api.sanity.io if false
  final bool useCdn;

  /// yyyy-mm-dd api version number
  final String apiVersion;

  /// sets a tag to all queries
  final String? requestTagPrefix;

  /// lets the client know that the user plans on using graphql in fetch over groq
  final bool graphQl;

  /// makes it so the client can stream data live using observables
  final bool live;

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
    perspective,
    bool? useCdn,
    String? apiVersion,
    this.graphQl = false,
    this.requestTagPrefix,
    this.live = false,
  })  : useCdn = useCdn ?? true,
        apiVersion = apiVersion ?? defaultApiVersion {
    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}
