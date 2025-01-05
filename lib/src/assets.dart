/// optional parameter enum for setting the image fill values.
enum Fit {
  /// fill bounds
  fill,

  /// maximum fill bounds
  fillMax,

  /// fill to crop dimensions
  crop,

  /// fill to clip dimensions
  clip,

  /// scale to width and height
  scale,

  /// minimum fill
  min,

  /// maximum fill
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

/// image parameter settings
class ImageOptions {
  late final Map<String, dynamic> _parameters = {};

  /// image width in pixels
  final int? width;

  /// image height in pixels
  final int? height;

  /// blur value 0 - 200
  final int? blur;

  /// hex color to set the background: #FFFFFF
  final String? backgroundColor;

  /// crop alignment position relative to image dimensions
  final CropPosition? cropPosition;

  /// image DPI
  final String? devicePixelRatio;

  /// scale image in various ways to the suplied width an height
  final Fit? fit;

  /// transform the image to flip vertical or horizontal or both
  final Flip? flip;

  /// meta information for the focal position X
  final double? focalPointX;

  /// meta information for the focal position Y
  final double? focalPointy;

  /// manually set the format to jpg, pjpg, png, or webp
  final Format? format;

  /// invert the image
  final bool? invert;

  ///
  final int? frame;

  /// maximum height of the image in pixels
  final int? maxHeight;

  /// maximum width of the image in pixels
  final int? maxWidth;

  /// minimum width of the image in pixels
  final int? minWidth;

  /// minimum height of the image in pixels
  final int? minHeight;

  /// sets the image rotation in degress 0, 90, 180, 270 are the only supported values
  final int? orientation;

  /// this is listed as "sat" in sanity docs. but the value makes no sense so this
  /// sets the sat to the only value it can be which is greyscale.
  final bool? greyscale;

  /// image quality from 0 - 100
  final int? quality;

  /// adds padding around the image pushing it inward.
  final int? padding;

  /// used when setting the fit value to Fit.crop
  final ImageCrop? cropDimensions;

  /// image sharpness from 0 - 100
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

  /// converts the option data to a map
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
