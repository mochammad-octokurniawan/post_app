import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:post_app/features/posts/domain/entities/post_sort_type.dart';
import 'package:post_app/features/posts/presentation/bloc/bloc.dart';
import 'package:post_app/features/posts/presentation/widgets/post_widgets.dart';
import 'package:post_app/features/posts/presentation/widgets/post_sort_widget.dart';

/// Posts List Page
/// 
/// Displays all posts in a scrollable list with:
/// - Pull-to-refresh functionality
/// - Loading states
/// - Error handling
/// - Empty state
/// - Navigation to detail page
class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  late final PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    // Load posts on page load
    _postBloc.add(const GetAllPostsEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        elevation: 0,
        actions: [
          // Sort button
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              final currentSort = state is PostListLoaded
                  ? state.sortType
                  : PostSortType.idAscending;

              return IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort posts',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => PostSortBottomSheet(
                      currentSortType: currentSort,
                      onSortSelected: (sortType) {
                        _postBloc.add(GetAllPostsEvent(sortType: sortType));
                      },
                    ),
                  );
                },
              );
            },
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _postBloc.add(const RefreshPostsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostInitial || state is PostListLoading) {
            return const LoadingWidget(message: 'Loading posts...');
          }

          if (state is PostError) {
            return ErrorMessageWidget(
              message: state.message,
              onRetry: () {
                _postBloc.add(const GetAllPostsEvent());
              },
            );
          }

          if (state is PostListLoaded) {
            if (state.posts.isEmpty) {
              return EmptyWidget(
                message: 'No posts available',
                actionText: 'Create Post',
                onAction: () {
                  context.go('/posts/create');
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _postBloc.add(const RefreshPostsEvent());
                // Wait for state change
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostTile(
                    post: post,
                    onTap: () {
                      context.go('/posts/${post.id}');
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/posts/create');
        },
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
}
