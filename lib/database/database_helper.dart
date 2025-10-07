import 'dart:developer' as dev;

import 'package:hive_flutter/hive_flutter.dart';
import '../models/post.dart';

class DatabaseHelper {
  static const String postsBoxName = 'posts_box';
  static const String readPostsBoxName = 'read_posts_box';

  static Box<Post>? postsBox;
  static Box<int>? readPostsBox;

  // Initialize Hive boxes
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PostAdapter());
      }
      postsBox = await Hive.openBox<Post>(postsBoxName);
      readPostsBox = await Hive.openBox<int>(readPostsBoxName);
    } catch (e) {
      dev.log('Error initializing Hive', error: e);
    }
  }

  // Save posts to local storage
  static Future<void> savePosts(List<Post> posts) async {
    try {
      if (postsBox == null) await init();
      await postsBox!.clear();
      for (int i = 0; i < posts.length; i++) {
        await postsBox!.put(i, posts[i]);
      }
    } catch (e) {
      dev.log('Error saving posts', error: e);
    }
  }

  // Load posts from local storage
  static Future<List<Post>> loadPosts() async {
    try {
      if (postsBox == null) await init();

      return postsBox!.values.toList();
    } catch (e) {
      dev.log('Error loading posts', error: e);
    }
    return [];
  }

  // Save read posts IDs
  static Future<void> saveReadPosts(List<int> readPostIds) async {
    try {
      if (readPostsBox == null) await init();
      await readPostsBox!.clear();
      for (int i = 0; i < readPostIds.length; i++) {
        await readPostsBox!.put(i, readPostIds[i]);
      }
    } catch (e) {
      dev.log('Error saving read posts', error: e);
    }
  }

  // Load read posts IDs
  static Future<List<int>> loadReadPosts() async {
    try {
      if (readPostsBox == null) await init();

      return readPostsBox!.values.toList();
    } catch (e) {
      dev.log('Error loading read posts', error: e);
    }
    return [];
  }

  // Add a single post
  static Future<void> addPost(Post post) async {
    try {
      if (postsBox == null) await init();

      await postsBox!.add(post);
    } catch (e) {
      dev.log('Error adding post', error: e);
    }
  }

  // Update a post
  static Future<void> updatePost(int index, Post post) async {
    try {
      if (postsBox == null) await init();

      await postsBox!.putAt(index, post);
    } catch (e) {
      dev.log('Error updating post', error: e);
    }
  }

  // Mark a post as read
  static Future<void> markPostAsRead(int postId) async {
    try {
      if (readPostsBox == null) await init();
      if (!readPostsBox!.values.contains(postId)) {
        await readPostsBox!.add(postId);
      }
    } catch (e) {
      dev.log('Error marking post as read', error: e);
    }
  }

  // Check if a post is read
  static Future<bool> isPostRead(int postId) async {
    try {
      if (readPostsBox == null) await init();

      return readPostsBox!.values.contains(postId);
    } catch (e) {
      dev.log('Error checking read status', error: e);
    }
    return false;
  }

  // Clear all cached data
  static Future<void> clearCache() async {
    try {
      if (postsBox != null) {
        await postsBox!.clear();
      }
      if (readPostsBox != null) {
        await readPostsBox!.clear();
      }
    } catch (e) {
      dev.log('Error clearing cache', error: e);
    }
  }

  // Close boxes
  static Future<void> close() async {
    try {
      await postsBox?.close();
      await readPostsBox?.close();
    } catch (e) {
      dev.log('Error closing boxes', error: e);
    }
  }
}
