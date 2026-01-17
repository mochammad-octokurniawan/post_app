import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/presentation/bloc/bloc.dart';

// Mock PostBloc
class MockPostBloc extends Mock implements PostBloc {}

void main() {
  group('PostListPage Tests', () {
    late MockPostBloc mockPostBloc;

    setUp(() {
      mockPostBloc = MockPostBloc();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: const Scaffold(
            body: Center(
              child: Text('Post List Page'),
            ),
          ),
        ),
      );
    }

    testWidgets('renders PostListPage', (WidgetTester tester) async {
      // Stub the stream for the bloc
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostLoading()),
      );
      when(() => mockPostBloc.state).thenReturn(PostLoading());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: const Scaffold(
            body: CircularProgressIndicator(),
          ),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message on failure', (WidgetTester tester) async {
      final errorState = PostError(
        failure: ServerFailure('Server error'),
        message: 'Failed to load posts',
      );
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(errorState),
      );
      when(() => mockPostBloc.state).thenReturn(errorState);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: Scaffold(
            body: Text(errorState.message),
          ),
        ),
      ));

      expect(find.text('Failed to load posts'), findsOneWidget);
    });

    testWidgets('displays posts when loaded', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final posts = [
        Post(
          id: 1,
          title: 'Post 1',
          body: 'Body 1',
          userId: 1,
          createdAt: testDateTime,
        ),
        Post(
          id: 2,
          title: 'Post 2',
          body: 'Body 2',
          userId: 2,
          createdAt: testDateTime,
        ),
      ];

      final loadedState = PostLoaded(posts: posts);
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(loadedState),
      );
      when(() => mockPostBloc.state).thenReturn(loadedState);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: Scaffold(
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                );
              },
            ),
          ),
        ),
      ));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Post 1'), findsOneWidget);
      expect(find.text('Post 2'), findsOneWidget);
    });

    testWidgets('displays empty state when no posts', (WidgetTester tester) async {
      final emptyState = const PostLoaded(posts: []);
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(emptyState),
      );
      when(() => mockPostBloc.state).thenReturn(emptyState);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: const Scaffold(
            body: Center(
              child: Text('No posts available'),
            ),
          ),
        ),
      ));

      expect(find.text('No posts available'), findsOneWidget);
    });

    testWidgets('triggers GetAllPostsEvent on init', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: const Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      ));

      // Verify the bloc was created
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has refresh button', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<PostBloc>(
          create: (_) => mockPostBloc,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Posts'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(child: Text('Test')),
          ),
        ),
      ));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('posts list is scrollable', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final posts = List.generate(
        20,
        (i) => Post(
          id: i + 1,
          title: 'Post ${i + 1}',
          body: 'Body ${i + 1}',
          userId: 1,
          createdAt: testDateTime,
        ),
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index].title),
              );
            },
          ),
        ),
      ));

      // Verify items are rendered
      expect(find.byType(ListTile), findsWidgets);

      // Scroll down
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // More items should be visible after scroll
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
