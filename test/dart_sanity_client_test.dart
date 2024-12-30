import 'package:dart_sanity_client/dart_sanity_client.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = 'hello';

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome, 'hello');
    });
  });
}
