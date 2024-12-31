import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/file_decoder.dart';

class ImageOptions {
  String parameters = '';
  void width(int width) {
    parameters += '?$width';
  }

  void height(int height) {
    parameters += '?$height';
  }

  String url() {
    return parameters;
  }
}

// ignore: camel_case_types
class URI_Builder {
  SanityConfig config;
  URI_Builder({required this.config});

  Uri image(final String refId) {
    return Uri(
      scheme: 'https',
      host: 'cdn.sanity.io',
      path:
          '/images/${config.projectId}/${config.dataset}/${FileDecoder.image(refId).asset}',
    );
  }

  Uri file(
    final String refId,
  ) {
    return Uri(
      scheme: 'https',
      host: 'cdn.sanity.io',
      path:
          '/file/${config.projectId}/${config.dataset}/${FileDecoder.file(refId).asset}',
    );
  }

  // static _query()
  Uri query(
    String query, {
    Map<String, dynamic>? params,
  }) {
    final Map<String, dynamic> queryParameters = {
      'query': query,
      if (params != null) ...params,
    };
    return Uri(
      scheme: 'https',
      host: '${config.projectId}.api.sanity.io',
      path: '/${config.apiVersion}/data/query/${config.dataset}',
      queryParameters: queryParameters,
    );
  }
}
