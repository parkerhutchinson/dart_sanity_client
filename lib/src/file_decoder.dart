/// image type
class Image {
  /// asset string value
  final String asset;

  /// image width in pixels
  final int width;

  /// image height in pixels
  final int height;

  /// file type
  final String type;
  // ignore: public_member_api_docs
  Image({
    required this.asset,
    required this.width,
    required this.height,
    required this.type,
  });
}

/// file type
class File {
  /// asset string value
  final String asset;

  /// file type
  final String type;
  // ignore: public_member_api_docs
  File({
    required this.asset,
    required this.type,
  });
}

/// static class getter for converting an asset ref into its individual parts
class FileDecoder {
  /// get image asset from imageRef string
  static Image image(final String imageRef) {
    final parts = imageRef.split("-");
    final [prefix, id, dimensions, format] = parts;
    final [w, h] = dimensions.split('x');

    assert(prefix.toLowerCase() == 'image',
        'Invalid file reference: $imageRef. Must begin with "image"');

    return Image(
      asset: '$id-${w}x$h.$format',
      width: int.parse(w, radix: 10),
      height: int.parse(h, radix: 10),
      type: format,
    );
  }

  /// get file assset from fileRef string
  static File file(final String fileRef) {
    final parts = fileRef.split('-');
    final [prefix, id, format] = parts;

    assert(prefix.toLowerCase() == 'file',
        'Invalid file reference: $fileRef. Must begin with "file"');

    return File(asset: '$id.$format', type: format);
  }

  /// used to check the type is either image or file
  static String? type(final String ref) {
    final parts = ref.split('-');

    return parts.isNotEmpty ? parts[0] : null;
  }
}
