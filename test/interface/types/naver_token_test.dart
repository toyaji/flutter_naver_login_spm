import 'package:flutter_test/flutter_test.dart';
import 'package:naver_login_flutter/interface/types/naver_token.dart';

void main() {
  group('NaverToken', () {
    final Map<String, dynamic> mockMap = {
      'accessToken': 'sample_access_token',
      'refreshToken': 'sample_refresh_token',
      'expiresAt': '2030-12-31T23:59:59.000',
      'tokenType': 'bearer',
    };

    test('fromMap should parse map correctly', () {
      final token = NaverToken.fromMap(mockMap);

      expect(token.accessToken, 'sample_access_token');
      expect(token.refreshToken, 'sample_refresh_token');
      expect(token.expiresAt, '2030-12-31T23:59:59.000');
      expect(token.tokenType, 'bearer');
    });

    test('empty should return a token with empty fields', () {
      final token = NaverToken.empty();

      expect(token.accessToken, isEmpty);
      expect(token.refreshToken, isEmpty);
      expect(token.expiresAt, isEmpty);
      expect(token.tokenType, isEmpty);
    });

    test('toMap should convert object to map correctly', () {
      final token = NaverToken.fromMap(mockMap);
      final map = token.toMap();

      expect(map['accessToken'], 'sample_access_token');
      expect(map['refreshToken'], 'sample_refresh_token');
      expect(map['expiresAt'], '2030-12-31T23:59:59.000');
      expect(map['tokenType'], 'bearer');
    });

    test('isValid should return true if expiresAt is in the future', () {
      // Create a token with a future date
      final futureDate = DateTime.now().add(const Duration(days: 1)).toIso8601String();
      final token = NaverToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: futureDate,
        tokenType: 'bearer',
      );

      expect(token.isValid(), isTrue);
    });

    test('isValid should return false if expiresAt is in the past', () {
      // Create a token with a past date
      final pastDate = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final token = NaverToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: pastDate,
        tokenType: 'bearer',
      );

      expect(token.isValid(), isFalse);
    });

    test('isValid should return false if expiresAt is invalid', () {
      const token = NaverToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: 'invalid_date',
        tokenType: 'bearer',
      );

      expect(token.isValid(), isFalse);
    });

    test('toString should return correct string format', () {
      final token = NaverToken.fromMap(mockMap);
      final str = token.toString();
      expect(str, contains('accessToken: sample_access_token'));
      expect(str, contains('refreshToken: sample_refresh_token'));
    });

    test('operator == should work correctly', () {
      final token1 = NaverToken.fromMap(mockMap);
      final token2 = NaverToken.fromMap(mockMap);
      const token3 = NaverToken(
        accessToken: 'diff',
        refreshToken: 'diff',
        expiresAt: 'diff',
        tokenType: 'diff',
      );

      expect(token1, equals(token2));
      expect(token1, isNot(equals(token3)));
    });

    test('hashCode should be consistent', () {
      final token1 = NaverToken.fromMap(mockMap);
      final token2 = NaverToken.fromMap(mockMap);

      expect(token1.hashCode, equals(token2.hashCode));
    });
  });
}
