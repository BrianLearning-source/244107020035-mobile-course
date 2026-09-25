// AI Generated

import 'package:flutter_test/flutter_test.dart';
import 'package:allweek/data/models/comment.dart';

void main() {
  group('Comment Model Test', () {
    test('should parse valid JSON correctly', () {
      final json = {
        'postId': 1,
        'id': 101,
        'name': 'Test User',
        'email': 'test@mail.com',
        'body': 'This is a test comment',
      };

      final result = Comment.fromJson(json);

      expect(result.id, 101);
      expect(result.name, 'Test User');
    });
  });
}