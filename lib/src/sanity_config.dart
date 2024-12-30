enum Perspective { published, previewDrafts, raw }

class SanityConfig {
  final String projectId;
  final String dataset;
  final Perspective perspective;
  final String? token;
  final bool useCdn;
  final String apiVersion;

  // latest sanity http API version
  static final String defaultApiVersion = (() {
    final today = DateTime.now();
    final parts = [
      today.year.toString(),
      today.month.toString().padLeft(2, '0'),
      today.day.toString().padLeft(2, '0')
    ].join('-');

    return 'v$parts';
  })();

  // unlick the other client this does not require the token be present
  SanityConfig({
    required this.projectId,
    required this.dataset,
    this.token,
    Perspective? perspective = Perspective.published,
    bool? useCdn = true,
    String? apiVersion,
  })  : useCdn = useCdn ?? true,
        apiVersion = apiVersion ?? defaultApiVersion,
        perspective = perspective ?? Perspective.raw {
    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}
