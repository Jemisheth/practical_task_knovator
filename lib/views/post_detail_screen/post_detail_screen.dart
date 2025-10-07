import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/post_detail_controller.dart';
import '../../utils/colors.dart';
import 'post_detail_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late PostDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PostDetailController());
    controller.fetchPostDetail(widget.postId);
  }

  @override
  void dispose() {
    controller.clearPost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text(
          'Post Details',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchPostDetail(widget.postId),
            icon: const Icon(Icons.refresh, color: AppColors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const PostDetailLoadingWidget();
        }

        if (controller.error.value.isNotEmpty) {
          return PostDetailErrorWidget(
            error: controller.error.value,
            onRetry: () => controller.fetchPostDetail(widget.postId),
          );
        }

        if (controller.post.value == null) {
          return const PostDetailEmptyWidget();
        }

        final post = controller.post.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeaderWidget(post: post),
              const SizedBox(height: 24),
              PostContentWidget(post: post),
              const SizedBox(height: 24),
              PostFooterWidget(post: post),
            ],
          ),
        );
      }),
    );
  }
}
