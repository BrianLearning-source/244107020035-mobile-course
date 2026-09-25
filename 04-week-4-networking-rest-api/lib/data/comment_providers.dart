// This is AI code

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'models/comment.dart';
import 'repositories/comment_repository.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref.watch(dioProvider));
});

class CommentListNotifier extends FamilyAsyncNotifier<List<Comment>, int> {
  @override
  Future<List<Comment>> build(int arg) async {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.fetchComments(arg);
  }
}

final commentListProvider =
    AsyncNotifierProvider.family<CommentListNotifier, List<Comment>, int>(
  CommentListNotifier.new,
);

/* Fixes

String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'slow connection or timeout. Check your internet and retry.';
      case DioExceptionType.connectionError:
        return 'Cannot reach the server. Check your internet connection.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) return 'Data not found (404).';
        if (code == 401 || code == 403) {
          return 'Access denied ($code). Check your credentials.';
        }
        return 'Server problem ($code). Try again later.';
      default:
        return 'A network error occurred. Try again.';
    }
  }
  return 'An unexpected error occurred: $error';
}
*/

//  AI Generated

String getCommentErrorMessage(Object error) {
  if (error is DioException) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection Timeout';
    } else if (error.response?.statusCode == 404) {
      return 'Comments not found';
    }
  }
  return 'An error occurred';
}

//