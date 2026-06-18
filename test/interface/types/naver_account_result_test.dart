import 'package:flutter_test/flutter_test.dart';
import 'package:naver_login_flutter/interface/types/naver_account_result.dart';

void main() {
  group('NaverAccountResult', () {
    final Map<String, dynamic> mockMap = {
      'id': '12345678',
      'email': 'test@naver.com',
      'name': '홍길동',
      'nickname': 'gildong',
      'profile_image': 'https://example.com/profile.jpg',
      'gender': 'M',
      'age': '20-29',
      'birthday': '01-01',
      'birthyear': '2000',
      'mobile': '010-1234-5678',
      'mobile_e164': '+821012345678',
    };

    test('fromMap should parse map correctly', () {
      final account = NaverAccountResult.fromMap(mockMap);

      expect(account.id, '12345678');
      expect(account.email, 'test@naver.com');
      expect(account.name, '홍길동');
      expect(account.nickname, 'gildong');
      expect(account.profileImage, 'https://example.com/profile.jpg');
      expect(account.gender, 'M');
      expect(account.age, '20-29');
      expect(account.birthday, '01-01');
      expect(account.birthYear, '2000');
      expect(account.mobile, '010-1234-5678');
      expect(account.mobileE164, '+821012345678');
    });

    test('toMap should convert object to map correctly', () {
      final account = NaverAccountResult.fromMap(mockMap);
      final map = account.toMap();

      expect(map['id'], '12345678');
      expect(map['email'], 'test@naver.com');
      expect(map['name'], '홍길동');
      expect(map['nickname'], 'gildong');
      expect(map['profileImage'], 'https://example.com/profile.jpg');
      expect(map['gender'], 'M');
      expect(map['age'], '20-29');
      expect(map['birthday'], '01-01');
      expect(map['birthYear'], '2000');
      expect(map['mobile'], '010-1234-5678');
      expect(map['mobileE164'], '+821012345678');
    });

    test('operator == should work correctly', () {
      final account1 = NaverAccountResult.fromMap(mockMap);
      final account2 = NaverAccountResult.fromMap(mockMap);
      final account3 = NaverAccountResult(id: 'different_id');

      expect(account1, equals(account2));
      expect(account1, isNot(equals(account3)));
    });

    test('hashCode should be consistent', () {
      final account1 = NaverAccountResult.fromMap(mockMap);
      final account2 = NaverAccountResult.fromMap(mockMap);

      expect(account1.hashCode, equals(account2.hashCode));
    });
  });
}
