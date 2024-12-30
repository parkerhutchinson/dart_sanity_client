import 'package:test/test.dart';

void main() async {
  // dotenv.get('.env.dev');
  group('A group of tests', () {
    // final client = DartSanityClient(
    //   SanityConfig(
    //     dataset: DotEnv().get('dataset'),
    //     projectId: DotEnv().get('projectId'),
    //   ),
    // );

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect('awesome', 'hello');
    });
  });
}
