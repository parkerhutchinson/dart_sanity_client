import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/file_decoder.dart';
import 'package:dart_sanity_client/src/assets.dart';

// ignore: camel_case_types
class URI_Builder {
  SanityConfig config;
  URI_Builder({required this.config});

  /// actions and transactions api
  Uri action() {
    return Uri(
      scheme: 'https',
      host: '${config.projectId}.api.sanity.io',
      path: '/${config.apiVersion}/data/actions/${config.dataset}',
    );
  }

  /// using the ref id of the image and provided parameter options construct a cdn path for the image asset.
  Uri image(final String refId, {final ImageOptions? options}) {
    return Uri(
      scheme: 'https',
      host: 'cdn.sanity.io',
      path:
          '/images/${config.projectId}/${config.dataset}/${FileDecoder.image(refId).asset}',
      queryParameters: options!.map(),
    );
  }

  Uri file(
    final String refId,
  ) {
    return Uri(
      scheme: 'https',
      host: 'cdn.sanity.io',
      path:
          '/files/${config.projectId}/${config.dataset}/${FileDecoder.file(refId).asset}',
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
