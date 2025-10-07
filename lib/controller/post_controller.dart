import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../database/database_helper.dart';
import '../utils/filter_type.dart';

class PostController extends GetxController {
  final RxList<Post> posts = <Post>[].obs;
  final RxList<Post> filteredPosts = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<FilterType> currentFilter = FilterType.all.obs;
  
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  @override
  void onInit() {
    super.onInit();
    filteredPosts.value = <Post>[];
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // First, try to load from local storage
      await loadDataFromLocalStorage();
      
      // Then fetch from API in background
      await fetchPostDataFromAPI();
      
    } catch (e) {
      error.value = 'Failed to load posts: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDataFromLocalStorage() async {
    try {
      final cachedPosts = await DatabaseHelper.loadPosts();
      final readPostsIds = await DatabaseHelper.loadReadPosts();
      
      if (cachedPosts.isNotEmpty) {
        // Mark posts as read based on local storage
        for (var post in cachedPosts) {
          post.isRead = readPostsIds.contains(post.id);
        }
        
        posts.value = cachedPosts;
        applyFilter();
      }
    } catch (e) {
      dev.log('Error loading from local storage', error: e);
    }
  }

  Future<void> fetchPostDataFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body);
        final fetchedPosts = postsJson.map((json) => Post.fromJson(json)).toList();
        final readPostsIds = posts.where((post) => post.isRead).map((post) => post.id).toSet();
        for (var post in fetchedPosts) {
          post.isRead = readPostsIds.contains(post.id);
        }
        posts.value = fetchedPosts;
        applyFilter();
        await DatabaseHelper.savePosts(fetchedPosts);
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      if (posts.isEmpty) {
        error.value = 'Failed to load posts: $e';
      }
    }
  }


  Future<void> markAsRead(int postId) async {
    try {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        posts[postIndex] = posts[postIndex].copyWith(isRead: true);
        applyFilter();
        await DatabaseHelper.markPostAsRead(postId);
      }
    } catch (e) {
      dev.log('Error marking post as read', error: e);
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  // Filter methods
  void setFilter(FilterType filter) {
    currentFilter.value = filter;
    applyFilter();
  }

  void applyFilter() {
    if (posts.isEmpty) {
      filteredPosts.value = <Post>[];
      return;
    }
    
    switch (currentFilter.value) {
      case FilterType.all:
        filteredPosts.value = List.from(posts);
        break;
      case FilterType.read:
        filteredPosts.value = posts.where((post) => post.isRead).toList();
        break;
      case FilterType.unread:
        filteredPosts.value = posts.where((post) => !post.isRead).toList();
        break;
    }
  }

  // Get filter statistics
  int get totalPosts => posts.length;
  int get readPosts => posts.where((post) => post.isRead).length;
  int get unreadPosts => posts.where((post) => !post.isRead).length;
  int get filteredPostsCount => filteredPosts.length;
}
