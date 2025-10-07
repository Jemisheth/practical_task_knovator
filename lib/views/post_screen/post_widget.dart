import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/post_controller.dart';
import '../../models/post.dart';
import '../../utils/colors.dart';
import '../post_detail_screen/post_detail_screen.dart';

class PostCardWidget extends StatelessWidget {
  final Post post;
  final PostController controller;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: post.isRead ? AppColors.white : AppColors.lightYellow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Mark as read
            await controller.markAsRead(post.id);
            
            // Navigate to detail screen
            Get.to(() => PostDetailScreen(postId: post.id));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostHeader(),
                const SizedBox(height: 12),
                _buildPostTitle(),
                const SizedBox(height: 8),
                _buildPostBody(),
                const SizedBox(height: 12),
                _buildPostFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Post #${post.id}',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        if (post.isRead)
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildPostTitle() {
    return Text(
      post.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: post.isRead ? AppColors.textSecondary : AppColors.textPrimary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPostBody() {
    return Text(
      post.body,
      style: TextStyle(
        fontSize: 14,
        color: post.isRead ? AppColors.textHint : AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPostFooter() {
    return Row(
      children: [
        const Icon(
          Icons.person,
          size: 16,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 4),
        Text(
          'User ${post.userId}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textHint,
        ),
      ],
    );
  }
}

class PostLoadingWidget extends StatelessWidget {
  const PostLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}

class PostErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const PostErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class PostEmptyWidget extends StatelessWidget {
  const PostEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No posts available',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }
}
