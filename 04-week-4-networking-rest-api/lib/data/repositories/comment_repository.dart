// This is AI Code

import 'package:dio/dio.dart';
import '../models/comment.dart';

class CommentRepository {
  final Dio _dio;

  CommentRepository(this._dio);

  Future<List<Comment>> fetchComments(int postId) async {
    // Menambahkan timeout 10 detik secara spesifik di method
    final response = await _dio.get(
      '/comments',
      queryParameters: {'postId': postId},
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final data = response.data as List;
    return data.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
  }
}