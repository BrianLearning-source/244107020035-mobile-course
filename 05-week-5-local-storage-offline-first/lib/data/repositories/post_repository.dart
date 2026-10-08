import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../models/post.dart';
import '../local/db.dart';

class PostRepository {
  PostRepository(this._dio, this._db);
  final Dio _dio;
  final Database _db;

  Future<List<Post>> readCachedPosts() async {
    final rows = await _db.query('cached_posts', orderBy: 'id ASC');
    return rows.map((row) {
      final payload = jsonDecode(row['payload'] as String);
      return Post.fromJson(payload as Map<String, dynamic>);
    }).toList();
  }

  Future<void> refreshPostsInBackground() async {
    try {
      final response = await _dio.get('/posts');

      final posts = (response.data as List)
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();

      await _db.transaction((txn) async {
        await txn.delete('cached_posts');

        for (final post in posts) {
          await txn.insert('cached_posts', {
            'id': post.id,
            'payload': jsonEncode(post.toJson()),
            'cached_at': DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } catch (e) {
    }
  }

  Future<List<Post>> loadPostsCacheFirst() async {
    final cached = await readCachedPosts(); // from the cached_posts table
    // 1. Return the cache immediately so the UI is never blank offline.
    // 2. In the background: fetch via Dio -> save to cached_posts
    //    -> invalidate the provider.
    refreshPostsInBackground();
    return cached;
  }
}
