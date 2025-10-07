import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostDetailController extends GetxController {
  final Rx<Post?> post = Rx<Post?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<void> fetchPostDetail(int postId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> postJson = json.decode(response.body);
        post.value = Post.fromJson(postJson);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      error.value = 'Failed to load post: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void clearPost() {
    post.value = null;
    error.value = '';
  }
}
