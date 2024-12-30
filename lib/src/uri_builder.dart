// import 'package:dart_sanity_client/src/sanity_config.dart';

// ignore: camel_case_types
enum URI_Type { image, file, query }

// ignore: camel_case_types
class URI_Builder<TConfig> {
  static _image(
    final String refId, {
    final int? width,
    final int? height,
    final int? devicePixelRatio,
    final int? quality,
    final String? format,
  }) {}

  factory URI_Builder({URI_Type type = URI_Type.query}) {
    return _image('asdf');
  }
}
