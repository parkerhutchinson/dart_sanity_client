// ignore: public_member_api_docs
class SanityException implements Exception {
  // ignore: public_member_api_docs
  SanityException([
    this._message,
    this._prefix,
  ]);

  final String? _message;
  final String? _prefix;

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// ignore: public_member_api_docs
class FetchDataException extends SanityException {
  // ignore: public_member_api_docs
  FetchDataException([String? message])
      : super(message, 'Error During Communication: ');
}

// ignore: public_member_api_docs
class BadRequestException extends SanityException {
  // ignore: public_member_api_docs
  BadRequestException([String? message]) : super(message, 'Invalid Request: ');
}

// ignore: public_member_api_docs
class UnauthorizedException extends SanityException {
  // ignore: public_member_api_docs
  UnauthorizedException([String? message]) : super(message, 'Unauthorized: ');
}

// ignore: public_member_api_docs
class InvalidInputException extends SanityException {
  // ignore: public_member_api_docs
  InvalidInputException([String? message]) : super(message, 'Invalid Input: ');
}

// ignore: public_member_api_docs
class FormatDataException extends SanityException {
  // ignore: public_member_api_docs
  FormatDataException([String? message])
      : super(message, 'Error During Parsing: ');
}
