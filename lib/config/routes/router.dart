import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/presentation/pages/post_list_page.dart';
import 'package:post_app/features/posts/presentation/pages/post_detail_page.dart';
import 'package:post_app/features/posts/presentation/pages/post_form_page.dart';

/// Global GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/posts',
  redirect: (context, state) {
    // Future: Add authentication guard logic here
    // if (!isAuthenticated && state.location != '/login') {
    //   return '/login';
    // }
    return null;
  },
  routes: [
    GoRoute(
      path: '/posts',
      name: 'posts_list',
      builder: (context, state) => PostListPage(),
      routes: [
        // Create route must come BEFORE :id route to prevent "create" from being parsed as ID
        GoRoute(
          path: 'create',
          name: 'post_create',
          builder: (context, state) => PostFormPage(),
        ),
        GoRoute(
          path: ':id',
          name: 'post_detail',
          builder: (context, state) {
            final postId = int.parse(state.pathParameters['id']!);
            return PostDetailPage(postId: postId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              name: 'post_edit',
              builder: (context, state) {
                final post = state.extra as Post?;
                return PostFormPage(postToEdit: post);
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Page not found', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/posts'),
            child: Text('Go Back Home'),
          ),
        ],
      ),
    ),
  ),
);
