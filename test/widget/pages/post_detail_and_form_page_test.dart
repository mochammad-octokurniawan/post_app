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
  group('PostDetailPage Tests', () {
    late MockPostBloc mockPostBloc;

    setUp(() {
      mockPostBloc = MockPostBloc();
    });

    testWidgets('renders detail page', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final testPost = Post(
        id: 1,
        title: 'Test Post',
        body: 'Test Body',
        userId: 1,
        createdAt: testDateTime,
      );

      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              appBar: AppBar(title: const Text('Post Detail')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testPost.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(testPost.body),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Post Detail'), findsOneWidget);
      expect(find.text(testPost.title), findsOneWidget);
      expect(find.text(testPost.body), findsOneWidget);
    });

    testWidgets('displays post information correctly', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final testPost = Post(
        id: 42,
        title: 'Detailed Post Title',
        body: 'This is the detailed body of the post with complete information',
        userId: 7,
        createdAt: testDateTime,
      );

      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              appBar: AppBar(title: const Text('Post Detail')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(testPost.title),
                      const SizedBox(height: 8),
                      Text('ID: ${testPost.id}'),
                      Text('User: ${testPost.userId}'),
                      const SizedBox(height: 16),
                      Text(testPost.body),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Post Detail'), findsOneWidget);
      expect(find.text(testPost.title), findsOneWidget);
      expect(find.text('ID: 42'), findsOneWidget);
      expect(find.text('User: 7'), findsOneWidget);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostLoading()),
      );
      when(() => mockPostBloc.state).thenReturn(PostLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error state', (WidgetTester tester) async {
      final errorState = PostError(
        failure: ServerFailure('Post not found'),
        message: 'Post not found',
      );

      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(errorState),
      );
      when(() => mockPostBloc.state).thenReturn(errorState);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Center(
                child: Text(errorState.message),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Post not found'), findsOneWidget);
    });

    testWidgets('has action buttons', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Post Detail'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              ),
              body: const Center(child: Text('Content')),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('content is scrollable for long posts', (WidgetTester tester) async {
      final longBody = 'This is a very long post body that contains a lot of text. ' * 50;

      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Text(longBody),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('PostFormPage Tests', () {
    late MockPostBloc mockPostBloc;

    setUp(() {
      mockPostBloc = MockPostBloc();
    });

    testWidgets('renders form page', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              appBar: AppBar(title: const Text('New Post')),
              body: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Body'),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Create Post'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has title input field', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Form(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('has body input field', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Form(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Body'),
                  maxLines: 5,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('has submit button', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('can type in title field', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Form(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test Title');
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('can type in body field', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Form(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Body'),
                  maxLines: 5,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test body content');
      expect(find.text('Test body content'), findsOneWidget);
    });

    testWidgets('displays loading state on submit', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostLoading()),
      );
      when(() => mockPostBloc.state).thenReturn(PostLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays success message after submit', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final testPost = Post(
        id: 1,
        title: 'New Post',
        body: 'New Body',
        userId: 1,
        createdAt: testDateTime,
      );

      final successState = PostCreated(
        post: testPost,
        message: 'Post created successfully',
      );

      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(successState),
      );
      when(() => mockPostBloc.state).thenReturn(successState);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Center(
                child: Text('Post created: ${testPost.title}'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Post created: New Post'), findsOneWidget);
    });

    testWidgets('form validation works', (WidgetTester tester) async {
      when(() => mockPostBloc.stream).thenAnswer(
        (_) => Stream.value(PostInitial()),
      );
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>(
            create: (_) => mockPostBloc,
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        formKey.currentState?.validate();
                      },
                      child: const Text('Validate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Title is required'), findsOneWidget);
    });
  });
}
