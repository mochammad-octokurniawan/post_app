import 'package:flutter/material.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';

/// Reusable widget displaying a single post in list format
/// 
/// Shows post ID, title, and a snippet of the body
/// Tappable to navigate to post detail
/// 
/// Parameters:
/// - [post]: Post entity to display
/// - [onTap]: Callback when post is tapped
class PostTile extends StatelessWidget {

  const PostTile({
    required this.post,
    required this.onTap,
    super.key,
  });
  /// The post data to display
  final Post post;

  /// Callback when tile is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Text(post.id.toString()),
        ),
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
}

/// Reusable card widget for displaying post details
/// 
/// Shows complete post information in a card format
/// Used in detail page and dialogs
/// 
/// Parameters:
/// - [post]: Post entity to display
class PostCard extends StatelessWidget {

  const PostCard({
    required this.post,
    super.key,
  });
  /// The post data to display
  final Post post;

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post ID and metadata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text('Post #${post.id}'),
                  avatar: const Icon(Icons.tag, size: 16),
                ),
                Chip(
                  label: Text('User #${post.userId}'),
                  avatar: const Icon(Icons.person, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Title',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              post.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Body
            Text(
              'Content',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Timestamps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${post.createdAt.toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  'Updated: ${post.updatedAt.toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
}

/// Reusable loading indicator widget
/// 
/// Shows centered spinner with optional message
class LoadingWidget extends StatelessWidget {

  const LoadingWidget({
    this.message,
    super.key,
  });
  /// Optional message to display below spinner
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
}

/// Reusable error widget
/// 
/// Shows error icon, message, and optional retry button
class ErrorMessageWidget extends StatelessWidget {

  const ErrorMessageWidget({
    required this.message,
    this.onRetry,
    super.key,
  });
  /// Error message to display
  final String message;

  /// Optional callback for retry button
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
}

/// Reusable empty state widget
/// 
/// Shows icon and message when no data available
class EmptyWidget extends StatelessWidget {

  const EmptyWidget({
    required this.message,
    this.actionText,
    this.onAction,
    super.key,
  });
  /// Message to display
  final String message;

  /// Optional action button text
  final String? actionText;

  /// Optional callback for action button
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
}
