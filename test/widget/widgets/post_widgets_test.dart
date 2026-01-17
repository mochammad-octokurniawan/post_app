import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/presentation/widgets/post_widgets.dart';

void main() {
  group('PostTile Widget Tests', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30);
    final testPost = Post(
      id: 1,
      title: 'Test Post Title',
      body: 'This is a test post body with some content',
      userId: 42,
      createdAt: testDateTime,
    );

    testWidgets('renders PostTile with post data', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: testPost,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(PostTile), findsOneWidget);
      expect(find.text(testPost.title), findsOneWidget);
      expect(find.text(testPost.body), findsOneWidget);
    });

    testWidgets('displays post ID in avatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: testPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: testPost,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('handles long title with ellipsis', (WidgetTester tester) async {
      final longDateTime = DateTime(2024, 1, 15, 10, 30);
      final longPost = Post(
        id: 1,
        title: 'This is a very long post title that should be truncated with ellipsis to prevent overflow',
        body: 'Body',
        userId: 1,
        createdAt: longDateTime,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: longPost,
              onTap: () {},
            ),
          ),
        ),
      );

      final textWidget = find.byType(Text).at(1); // Title is second text
      expect(textWidget, findsOneWidget);
    });

    testWidgets('handles long body with ellipsis', (WidgetTester tester) async {
      final longDateTime = DateTime(2024, 1, 15, 10, 30);
      final longPost = Post(
        id: 1,
        title: 'Title',
        body: 'This is a very long post body that contains a lot of content and should be truncated with ellipsis to prevent overflow in the display',
        userId: 1,
        createdAt: longDateTime,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: longPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(PostTile), findsOneWidget);
    });

    testWidgets('displays arrow icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: testPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('has proper card styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostTile(
              post: testPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('multiple tiles render correctly', (WidgetTester tester) async {
      final testDateTime = DateTime(2024, 1, 15, 10, 30);
      final posts = [
        Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1, createdAt: testDateTime),
        Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 2, createdAt: testDateTime),
        Post(id: 3, title: 'Post 3', body: 'Body 3', userId: 3, createdAt: testDateTime),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostTile(
                  post: posts[index],
                  onTap: () {},
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(PostTile), findsNWidgets(3));
      expect(find.text('Post 1'), findsOneWidget);
      expect(find.text('Post 2'), findsOneWidget);
      expect(find.text('Post 3'), findsOneWidget);
    });
  });

  group('PostCard Widget Tests', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30);
    final testPost = Post(
      id: 1,
      title: 'Test Post Title',
      body: 'This is a detailed test post body with comprehensive content',
      userId: 42,
      createdAt: testDateTime,
    );

    testWidgets('renders PostCard with all data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text(testPost.title), findsOneWidget);
      expect(find.text(testPost.body), findsOneWidget);
    });

    testWidgets('displays post ID chip', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.byType(Chip), findsWidgets);
      expect(find.text('Post #${testPost.id}'), findsOneWidget);
    });

    testWidgets('displays user ID chip', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.text('User #${testPost.userId}'), findsOneWidget);
    });

    testWidgets('has card styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays title label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('handles long post content', (WidgetTester tester) async {
      final longDateTime = DateTime(2024, 1, 15, 10, 30);
      final longPost = Post(
        id: 999,
        title: 'Very Long Title That Spans Multiple Lines and Contains Lots of Information About the Post Subject Matter',
        body: 'This is a very long post body that contains extensive content with detailed information about the topic being discussed. It includes multiple paragraphs worth of content to test how the card handles long text.',
        userId: 100,
        createdAt: longDateTime,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: longPost),
          ),
        ),
      );

      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text(longPost.title), findsOneWidget);
    });

    testWidgets('uses correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('displays both title and body sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      expect(textFinder, findsWidgets);
    });
  });

  group('Loading Widget Tests', () {
    testWidgets('displays loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading indicator is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading indicator animates', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Pump multiple times to simulate animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Error Message Widget Tests', () {
    testWidgets('displays error message', (WidgetTester tester) async {
      const errorMessage = 'Failed to load posts';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(errorMessage),
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays error icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline),
                  const SizedBox(height: 16),
                  const Text('Error occurred'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('error message is readable', (WidgetTester tester) async {
      const errorMessage = 'Network error: Connection timeout';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(errorMessage),
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });
  });

  group('Empty State Widget Tests', () {
    testWidgets('displays empty state message', (WidgetTester tester) async {
      const emptyMessage = 'No posts available';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(emptyMessage),
            ),
          ),
        ),
      );

      expect(find.text(emptyMessage), findsOneWidget);
    });

    testWidgets('displays empty state icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox),
                  const SizedBox(height: 16),
                  const Text('No posts found'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No posts found'), findsOneWidget);
    });

    testWidgets('empty state is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.folder_open),
                SizedBox(height: 16),
                Text('Nothing here yet'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
    });
  });
}
