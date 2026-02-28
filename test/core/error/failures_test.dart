import 'package:flutter_test/flutter_test.dart';
import 'package:newu_health/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('NetworkFailure has correct message', () {
      const failure = NetworkFailure(message: 'Test error', code: 500);
      expect(failure.message, 'Test error');
      expect(failure.code, 500);
    });

    test('NoConnectionFailure has default message', () {
      const failure = NoConnectionFailure();
      expect(failure.message, contains('No internet'));
    });

    test('TimeoutFailure has default message', () {
      const failure = TimeoutFailure();
      expect(failure.message, contains('timed out'));
    });

    test('CacheFailure has correct message', () {
      const failure = CacheFailure(message: 'Cache miss');
      expect(failure.message, 'Cache miss');
    });

    test('UnexpectedFailure has default message', () {
      const failure = UnexpectedFailure();
      expect(failure.message, contains('unexpected'));
    });
  });
}
