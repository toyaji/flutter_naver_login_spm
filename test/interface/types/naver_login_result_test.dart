import 'package:flutter_test/flutter_test.dart';
import 'package:naver_login_flutter/interface/types/naver_account_result.dart';
import 'package:naver_login_flutter/interface/types/naver_login_result.dart';
import 'package:naver_login_flutter/interface/types/naver_login_status.dart';
import 'package:naver_login_flutter/interface/types/naver_token.dart';

void main() {
  group('NaverLoginResult', () {
    final Map<String, dynamic> mockMap = {
      'status': 'loggedIn',
      'errorMessage': null,
      'accessToken': {
        'accessToken': 'token123',
        'refreshToken': 'refresh123',
        'expiresAt': '2030-12-31T00:00:00',
        'tokenType': 'bearer',
      },
      'account': {'id': 'user123', 'name': 'Test User'},
    };

    test('fromMap should parse valid map correctly', () {
      final result = NaverLoginResult.fromMap(mockMap);

      expect(result.status, NaverLoginStatus.loggedIn);
      expect(result.errorMessage, isNull);

      expect(result.accessToken, isNotNull);
      expect(result.accessToken!.accessToken, 'token123');

      expect(result.account, isNotNull);
      expect(result.account!.id, 'user123');
      expect(result.account!.name, 'Test User');
    });

    test('fromMap should parse error status correctly', () {
      final errorMap = {'status': 'error', 'errorMessage': 'Login Failed'};
      final result = NaverLoginResult.fromMap(errorMap);

      expect(result.status, NaverLoginStatus.error);
      expect(result.errorMessage, 'Login Failed');
      expect(result.accessToken, isNull);
      expect(result.account, isNull);
    });

    test('toMap should convert object to map correctly', () {
      final token = NaverToken(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresAt: '2030',
        tokenType: 'bearer',
      );
      final account = NaverAccountResult(id: 'user', name: 'User');

      final result = NaverLoginResult(
        status: NaverLoginStatus.loggedIn,
        accessToken: token,
        account: account,
        errorMessage: 'no error',
      );

      final map = result.toMap();
      expect(map['status'], NaverLoginStatus.loggedIn.index);
      expect(map['errorMessage'], 'no error');
      expect(map['accessToken']['accessToken'], 'token');
      expect(map['account']['id'], 'user');
    });
  });
}
