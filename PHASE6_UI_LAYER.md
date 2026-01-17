# Phase 6: UI Layer - Pages & Widgets Implementation

## 📋 Overview

Phase 6 completes the presentation layer by implementing reusable UI widgets and three main feature pages, all integrated with the BLoC state management system from Phase 4.

**Total: 6 files, 750 lines**

---

## 🎨 Reusable Widgets (`lib/features/posts/presentation/widgets/post_widgets.dart`)

### 1. **PostTile Widget** (List Item)
Displays a single post in a list view with a circular avatar preview.

**Features:**
- Circular avatar with post ID
- Title and body snippet (truncated to 2 lines)
- Tap callback for navigation
- Material design with hover effect

**Usage:**
```dart
PostTile(
  post: post,
  onTap: () {
    // Navigate to detail page
  },
)
```

**Key Code:**
```dart
class PostTile extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostTile({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${post.id}')),
      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
```

---

### 2. **PostCard Widget** (Detail Display)
Shows complete post details in a card format.

**Features:**
- Material Card container
- Full title and body display
- User ID and post ID as chips
- Creation/update timestamps
- Null safety for optional fields

**Usage:**
```dart
PostCard(post: post)
```

**Key Code:**
```dart
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(post.body),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('ID: ${post.id}')),
                Chip(label: Text('User: ${post.userId}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. **LoadingWidget**
Centered circular progress indicator with optional message.

**Features:**
- Centered spinner
- Optional message text
- Material Design styling

**Usage:**
```dart
LoadingWidget(message: 'Loading posts...')
```

**Key Code:**
```dart
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(message!),
          ]
        ],
      ),
    );
  }
}
```

---

### 4. **ErrorMessageWidget**
Displays error state with optional retry button.

**Features:**
- Error icon and message
- Optional retry callback
- Flexible layout for different screen sizes

**Usage:**
```dart
ErrorMessageWidget(
  message: 'Failed to load posts',
  onRetry: () => bloc.add(GetAllPostsEvent()),
)
```

**Key Code:**
```dart
class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessageWidget({
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
```

---

### 5. **EmptyWidget**
Displays empty state with optional action button.

**Features:**
- Inbox/folder icon
- Message text
- Optional action button
- Centered layout

**Usage:**
```dart
EmptyWidget(
  message: 'No posts found',
  actionLabel: 'Create Post',
  onAction: () => navigation.push(),
)
```

**Key Code:**
```dart
class EmptyWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyWidget({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
```

---

## 📄 Pages

### 1. **PostListPage** - Display All Posts (87 lines)
**Location:** `lib/features/posts/presentation/pages/post_list_page.dart`

**Features:**
- Fetches all posts on page init
- Pull-to-refresh functionality
- State-based UI rendering via BLoC
- Loading, error, and empty states
- Floating action button for create post (TODO: Phase 7)
- AppBar with refresh button

**State Flow:**
```
PostInitial → GetAllPostsEvent → PostLoading → LoadingWidget
                                   ↓
                            PostLoaded → ListView(PostTile)
                                   ↓
                            PostError → ErrorMessageWidget
                                   ↓
                            Empty → EmptyWidget
```

**Key Implementation:**
```dart
class PostListPage extends StatefulWidget {
  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  late final PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    _postBloc.add(GetAllPostsEvent());
  }

  Future<void> _onRefresh() async {
    _postBloc.add(RefreshPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return LoadingWidget(message: 'Fetching posts...');
          }
          
          if (state is PostError) {
            return ErrorMessageWidget(
              message: state.message,
              onRetry: () => _postBloc.add(GetAllPostsEvent()),
            );
          }
          
          if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return EmptyWidget(message: 'No posts available');
            }
            
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return PostTile(
                    post: state.posts[index],
                    onTap: () {
                      // TODO: Phase 7 - Navigate to detail
                    },
                  );
                },
              ),
            );
          }
          
          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Phase 7 - Navigate to form
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

### 2. **PostDetailPage** - Display Single Post (162 lines)
**Location:** `lib/features/posts/presentation/pages/post_detail_page.dart`

**Features:**
- Accepts post ID as parameter
- Fetches single post on init
- Edit and Delete action buttons
- Delete confirmation dialog
- Shows error state with retry
- Uses BLoC for state management

**State Flow:**
```
PostInitial → GetPostByIdEvent(id) → PostLoading → LoadingWidget
                                      ↓
                               PostLoaded → SingleChildScrollView(PostCard)
                                      ↓
                               PostError → ErrorMessageWidget
                                      ↓
                        Delete Confirmation → PostDeleted
```

**Key Implementation:**
```dart
class PostDetailPage extends StatefulWidget {
  final int postId;
  
  const PostDetailPage({required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late final PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    _postBloc.add(GetPostByIdEvent(id: widget.postId.toString()));
  }

  void _deletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _postBloc.add(DeletePostEvent(id: post.id));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post deleted')),
            );
            Navigator.pop(context);
          }
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return LoadingWidget();
            }
            
            if (state is PostError) {
              return ErrorMessageWidget(
                message: state.message,
                onRetry: () => _postBloc.add(
                  GetPostByIdEvent(id: widget.postId.toString()),
                ),
              );
            }
            
            if (state is PostLoaded && state.post != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: state.post!),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Phase 7 - Navigate to edit form
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => _deletePost(state.post!),
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            }
            
            return SizedBox();
          },
        ),
      ),
    );
  }
}
```

---

### 3. **PostFormPage** - Create/Edit Post (231 lines)
**Location:** `lib/features/posts/presentation/pages/post_form_page.dart`

**Features:**
- Supports both create and edit modes
- Form validation using core validators
- Pre-fills form in edit mode
- Disables fields during submission
- Shows loading state in button
- BLoC integration for create/update events

**Validation Rules:**
- **Title:** 1-100 characters (required)
- **Body:** 1-5000 characters (required)
- **User ID:** Integer value (required)

**State Flow:**
```
Create Mode (null) → Form Empty
Edit Mode (post) → Form Pre-filled

Form Valid → Submit → CreatePostEvent/UpdatePostEvent
                         ↓
                    PostCreated/PostUpdated → Navigate back
                         ↓
                    PostError → Show error snackbar
```

**Key Implementation:**
```dart
class PostFormPage extends StatefulWidget {
  final Post? postToEdit;
  
  const PostFormPage({this.postToEdit});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  late final PostBloc _postBloc;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _userIdController;
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    _formKey = GlobalKey();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _userIdController = TextEditingController(text: '1');
    
    // Pre-fill in edit mode
    if (widget.postToEdit != null) {
      _titleController.text = widget.postToEdit!.title;
      _bodyController.text = widget.postToEdit!.body;
      _userIdController.text = widget.postToEdit!.userId.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      if (widget.postToEdit != null) {
        _postBloc.add(
          UpdatePostEvent(
            id: widget.postToEdit!.id,
            title: _titleController.text,
            body: _bodyController.text,
            userId: int.parse(_userIdController.text),
          ),
        );
      } else {
        _postBloc.add(
          CreatePostEvent(
            title: _titleController.text,
            body: _bodyController.text,
            userId: int.parse(_userIdController.text),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postToEdit != null ? 'Edit Post' : 'Create Post'),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreated || state is PostUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success!')),
            );
            Navigator.pop(context);
          }
          if (state is PostError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => Validators.validatePostTitle(value ?? ''),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  enabled: !_isSubmitting,
                  maxLines: 8,
                  decoration: InputDecoration(labelText: 'Body'),
                  validator: (value) => Validators.validatePostBody(value ?? ''),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _userIdController,
                  enabled: !_isSubmitting,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'User ID'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'User ID required';
                    if (int.tryParse(value!) == null) return 'Invalid number';
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Submit'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🔄 BLoC Integration Pattern

All pages follow this pattern for BLoC integration:

```dart
// 1. Get reference in initState
late final PostBloc _postBloc;

@override
void initState() {
  super.initState();
  _postBloc = context.read<PostBloc>();
}

// 2. Add events to trigger state changes
_postBloc.add(GetAllPostsEvent());

// 3. Listen for specific states (dialogs, navigation, etc)
BlocListener<PostBloc, PostState>(
  listener: (context, state) {
    if (state is PostDeleted) {
      Navigator.pop(context);
    }
  },
  child: // ...
)

// 4. Build UI based on state
BlocBuilder<PostBloc, PostState>(
  builder: (context, state) {
    if (state is PostLoading) return LoadingWidget();
    if (state is PostError) return ErrorMessageWidget();
    if (state is PostLoaded) return ContentWidget();
    return SizedBox();
  },
)
```

---

## 📦 Exports

**`lib/features/posts/presentation/pages/pages.dart`** - Barrel export
```dart
export 'post_list_page.dart';
export 'post_detail_page.dart';
export 'post_form_page.dart';
```

**`lib/features/posts/presentation/widgets/widgets.dart`** - Barrel export
```dart
export 'post_widgets.dart';
```

---

## ✅ Phase 6 Checklist

- ✅ Created 5 reusable widgets (PostTile, PostCard, LoadingWidget, ErrorMessageWidget, EmptyWidget)
- ✅ Created PostListPage with pull-to-refresh and BLoC integration
- ✅ Created PostDetailPage with delete confirmation dialog
- ✅ Created PostFormPage with form validation and create/edit modes
- ✅ Integrated all pages with PostBloc events and states
- ✅ Created barrel exports for pages and widgets
- ✅ Fixed ErrorWidget naming conflict with Flutter framework
- ✅ Verified 0 compilation errors

---

## 🎯 Phase 6 Statistics

| Metric | Value |
|--------|-------|
| Files Created | 6 |
| Lines of Code | 750+ |
| Widgets | 5 |
| Pages | 3 |
| State-based Renderings | 18+ |
| BLoC Integrations | 3 |
| Forms | 1 |
| Dialogs | 1 |
| Compilation Errors | 0 |

---

## 📝 TODO: Phase 7 - Navigation

The following TODOs are placeholders for Phase 7 (GoRouter integration):

1. **PostListPage**
   - `onTap` callback in PostTile → Navigate to detail page
   - FloatingActionButton → Navigate to create form

2. **PostDetailPage**
   - Edit button → Navigate to edit form with post pre-filled
   - Delete confirmation → Already implemented, just needs pop

3. **PostFormPage**
   - Success states → Navigate back with post data (if needed)

---

## 🔗 Related Documentation

- **Phase 4**: `PHASE4_PRESENTATION_BLOC.md` - BLoC architecture and event/state definitions
- **Phase 5**: `PHASE5_DEPENDENCY_INJECTION.md` - Service locator setup
- **Phase 7**: (To be created) - GoRouter configuration and named routes
- **Core Validators**: `lib/core/utils/validators.dart` - Form validation rules

---

## 🚀 Next Steps

1. **Phase 7**: Configure GoRouter with named routes for all pages
   - Setup navigation based on routes
   - Connect all TODO navigation callbacks

2. **Phase 8+**: Testing and advanced features
   - Widget tests for UI components
   - Integration tests for navigation flows
