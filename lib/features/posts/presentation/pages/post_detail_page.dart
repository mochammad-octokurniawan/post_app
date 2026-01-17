import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/presentation/bloc/bloc.dart';
import 'package:post_app/features/posts/presentation/widgets/post_widgets.dart';

/// Post Detail Page
/// 
/// Displays detailed information for a single post with:
/// - Full post content (title, body, metadata)
/// - Edit button
/// - Delete button with confirmation
/// - Loading states
/// - Error handling
class PostDetailPage extends StatefulWidget {

  const PostDetailPage({
    required this.postId,
    super.key,
  });
  /// The post ID to display
  final int postId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late final PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    // Load specific post on page load
    _postBloc.add(GetPostByIdEvent(id: widget.postId.toString()));
  }

  @override
  Widget build(BuildContext context) => BlocListener<PostBloc, PostState>(
      listener: (listenerContext, state) {
        if (state is PostDeleted) {
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          // Navigate back to list
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go('/posts');
            }
          });
        }

        if (state is PostError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
          elevation: 0,
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostInitial || state is PostDetailLoading) {
              return const LoadingWidget(message: 'Loading post...');
            }

            if (state is PostError) {
              return ErrorMessageWidget(
                message: state.message,
                onRetry: () {
                  _postBloc.add(
                    GetPostByIdEvent(id: widget.postId.toString()),
                  );
                },
              );
            }

            if (state is PostDetailLoaded) {
              final post = state.post;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostCard(post: post),
                    const SizedBox(height: 24),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.go('/posts/${post.id}/edit', extra: post);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showDeleteConfirmation(
                              context,
                              post,
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const EmptyWidget(message: 'Post not found');
          },
        ),
      ),
    );

  /// Shows delete confirmation dialog
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [post]: Post to delete
  void _showDeleteConfirmation(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Post?'),
        content: Text(
          'Are you sure you want to delete "${post.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Delete post
              _postBloc.add(DeletePostEvent(id: post.id.toString()));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
