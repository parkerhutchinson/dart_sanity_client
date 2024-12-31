import 'package:dart_sanity_client/src/sanity_config.dart';
import 'package:dart_sanity_client/src/file_decoder.dart';

/// fill, fillMax, crop, clip, scale, min, max
enum Fit {
  fill,
  fillMax,
  crop,
  clip,
  scale,
  min,
  max,
}

enum Flip {
  h,
  v,
  hv,
}

enum CropPosition {
  left,
  top,
  right,
  bottom,
  center,
  focalpoint,
  entropy,
}

enum Format {
  jpg,
  pjpg,
  png,
  webp,
}

/// pixel dimensions for when crop is supplied.
class ImageCrop {
  final int width;
  final int height;
  final int left;
  final int top;
  ImageCrop({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
  });
}

class ImageOptions {
  late String parameters = '';
  final int? width;
  final int? height;
  final int? blur;
  final String? backgroundColor;
  final CropPosition? cropPosition;
  final String? devicePixelRatio;
  final Fit? fit;
  final Flip? flip;
  final double? focalPointX;
  final double? focalPointy;
  final Format? format;
  final bool? invert;
  final int? frame;
  final int? maxHeight;
  final int? maxWidth;
  final int? minWidth;
  final int? minHeight;
  final int? orientation;
  final bool? greyscale;
  final int? quality;
  final int? padding;
  final ImageCrop? cropDimensions;
  final int? sharp;

  /// sanity image query options https://www.sanity.io/docs/image-urls#dpr-d2055ee879ac
  ///
  /// supports everything except dl and dlRaw. I dont think with even flutters web target this could work.
  /// "auto" is also not supported but you can still request an exact "format"
  ImageOptions({
    this.width,
    this.height,
    this.blur,
    this.format,
    this.cropPosition,
    this.backgroundColor,
    this.devicePixelRatio,
    this.fit,
    this.flip,
    this.frame,
    this.focalPointX,
    this.focalPointy,
    this.invert,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.orientation,
    this.greyscale,
    this.quality,
    this.padding,
    this.cropDimensions,
    this.sharp,
  });

  String url() {
    final optionsMap = {
      'w': width,
      'h': height,
      'blur': blur,
      'fm': format,
      'crop': cropPosition,
      'bg': backgroundColor,
      'dpr': devicePixelRatio,
      'flip': flip,
      'fit': fit,
      'fp-x': focalPointX,
      'fp-y': focalPointy,
      'frame': frame,
      'invert': invert,
      'min-w': minWidth,
      'min-h': minHeight,
      'max-w': maxWidth,
      'max-h': maxHeight,
      'or': orientation,
      'sat': greyscale,
      'q': quality,
      'pad': padding,
      'rect': cropDimensions,
    };
    // this way we dont need a massive conditional block for all the options
    for (final mapEntry in optionsMap.entries) {
      final key = mapEntry.key;
      var value = mapEntry.value;
      // silly sanity only supports one value but instead of making this a bool they gave it an int value
      if (key == 'sat' && value == true) {
        value = -100;
      }
      if (value != null) {
        parameters += '?$key=$value';
      }
    }
    return parameters;
  }
}

// ignore: camel_case_types
class URI_Builder {
  SanityConfig config;
  URI_Builder({required this.config});

  Uri image(final String refId) {
    ImageOptions(frame: 1);
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
