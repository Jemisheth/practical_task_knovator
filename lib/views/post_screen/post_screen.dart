import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/post_controller.dart';
import '../../utils/colors.dart';
import '../../utils/filter_type.dart';
import 'post_widget.dart';
import 'filter_widget.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.put(PostController());

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const PostLoadingWidget();
        }

        if (controller.error.value.isNotEmpty && controller.posts.isEmpty) {
          return PostErrorWidget(
            error: controller.error.value,
            onRetry: () => controller.loadPosts(),
          );
        }

        if (controller.posts.isEmpty) {
          return const PostEmptyWidget();
        }

        return Column(
          children: [
            const FilterBarWidget(),
            const FilterStatsWidget(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshPosts(),
                color: AppColors.primary,
                child: buildPostsList(controller),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: buildFloatingActionButton(controller),
    );
  }

  Widget buildFloatingActionButton(PostController controller) {
    return FloatingActionButton(
      onPressed: () => showFilterBottomSheet(controller),
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.filter_list,
        color: AppColors.white,
      ),
    );
  }

  void showFilterBottomSheet(PostController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter Posts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ...FilterType.values.map((filterType) {
              return Obx(() => ListTile(
                leading: Icon(
                  getFilterIcon(filterType),
                  color: controller.currentFilter.value == filterType
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                title: Text(
                  filterType.displayName,
                  style: TextStyle(
                    color: controller.currentFilter.value == filterType
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: controller.currentFilter.value == filterType
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: controller.currentFilter.value == filterType
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  controller.setFilter(filterType);
                  Get.back();
                },
              ));
            }),
            const SizedBox(height: 20),
            const FilterStatsWidget(),
          ],
        ),
      ),
    );
  }

  IconData getFilterIcon(FilterType filterType) {
    switch (filterType) {
      case FilterType.all:
        return Icons.list;
      case FilterType.read:
        return Icons.check_circle;
      case FilterType.unread:
        return Icons.radio_button_unchecked;
    }
  }

  Widget buildPostsList(PostController controller) {
    if (controller.filteredPosts.isEmpty) {
      return buildEmptyFilterState(controller);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredPosts.length,
      itemBuilder: (context, index) {
        final post = controller.filteredPosts[index];
        return PostCardWidget(
          post: post,
          controller: controller,
        );
      },
    );
  }

  Widget buildEmptyFilterState(PostController controller) {
    String message;
    IconData icon;
    
    switch (controller.currentFilter.value) {
      case FilterType.read:
        message = 'No read posts yet';
        icon = Icons.check_circle_outline;
        break;
      case FilterType.unread:
        message = 'All posts have been read';
        icon = Icons.radio_button_checked;
        break;
      case FilterType.all:
        message = 'No posts available';
        icon = Icons.list;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter or refresh the posts',
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
