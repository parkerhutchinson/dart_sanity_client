class Image {
  final String asset;
  final int width;
  final int height;
  final String type;
  Image({
    required this.asset,
    required this.width,
    required this.height,
    required this.type,
  });
}

class File {
  final String asset;
  final String type;
  File({
    required this.asset,
    required this.type,
  });
}

class FileDecoder {
  // get image asset from imageRef string
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

  // get file assset from fileRef string
  static File file(final String fileRef) {
    final parts = fileRef.split('-');
    final [prefix, id, format] = parts;

    assert(prefix.toLowerCase() == 'file',
        'Invalid file reference: $fileRef. Must begin with "file"');

    return File(asset: '$id.$format', type: format);
  }

  static String? type(final String ref) {
    final parts = ref.split('-');

    return parts.isNotEmpty ? parts[0] : null;
  }
}
