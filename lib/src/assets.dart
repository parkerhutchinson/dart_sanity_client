/// optional parameter enum for setting the image fill values.
enum Fit {
  fill,
  fillMax,
  crop,
  clip,
  scale,
  min,
  max,
}

/// optional parameter enum for flipping the image.
enum Flip {
  /// flip image horizontally
  h,

  /// flip image vertically
  v,

  /// flip image horizontally and vertically
  hv,
}

/// optional parameter enum to set crop position relative to image dimensions.
enum CropPosition {
  /// left aligned crop position
  left,

  /// top aligned crop position
  top,

  /// right aligned crop position
  right,

  /// bottom aligned crop position
  bottom,

  /// center aligned crop position
  center,

  /// focalpoint aligned crop position
  focalpoint,

  /// approx aligned crop position based on image composition
  entropy,
}

/// optional parameter enum for setting image format
enum Format {
  /// jpg image format
  jpg,

  /// pjpg image format
  pjpg,

  /// png image format
  png,

  /// webp image format
  webp,
}

/// pixel dimensions for when crop is supplied.
class ImageCrop {
  /// image width in pixels
  final int width;

  /// image height in pixels
  final int height;

  /// image position left in pixels
  final int left;

  /// image position top in pixels
  final int top;

  /// imagecrop constructor
  ImageCrop({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
  });
}

class ImageOptions {
  late final Map<String, dynamic> _parameters = {};
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

  Map<String, dynamic> map() {
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
        _parameters[key] = '$value';
      }
    }
    return _parameters;
  }
}
