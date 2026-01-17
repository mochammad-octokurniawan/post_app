import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:post_app/core/utils/validators.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/presentation/bloc/bloc.dart';

/// Post Form Page
/// 
/// Form for creating or editing posts with:
/// - Title field validation (1-100 chars)
/// - Body field validation (1-5000 chars)
/// - User ID field
/// - Submit and cancel actions
/// - Loading states
/// - Error handling
/// 
/// Can be used for both create and edit modes
class PostFormPage extends StatefulWidget {

  const PostFormPage({
    this.postToEdit,
    super.key,
  });
  /// Optional post to edit (null for create mode)
  final Post? postToEdit;

  /// Is edit mode (true) or create mode (false)
  bool get isEditMode => postToEdit != null;

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _userIdController;
  late final GlobalKey<FormState> _formKey;
  late final PostBloc _postBloc;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _userIdController = TextEditingController();
    _postBloc = context.read<PostBloc>();

    // Pre-fill form if editing
    if (widget.isEditMode) {
      _titleController.text = widget.postToEdit!.title;
      _bodyController.text = widget.postToEdit!.body;
      _userIdController.text = widget.postToEdit!.userId.toString();
    } else {
      // Default user ID for create
      _userIdController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go('/posts');
            }
          });
        }

        if (state is PostUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go('/posts');
            }
          });
        }

        if (state is PostError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state is PostListLoading || state is PostDetailLoading) {
          setState(() => _isSubmitting = true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditMode ? 'Edit Post' : 'Create Post'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                Text(
                  'Title *',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter post title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  maxLines: 1,
                  maxLength: 100,
                  validator: (value) {
                    try {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      Validators.validatePostTitle(value);
                      return null;
                    } catch (e) {
                      return e.toString().replaceFirst('Exception: ', '');
                    }
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 24),

                // Body field
                Text(
                  'Content *',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    hintText: 'Enter post content',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 8,
                  maxLength: 5000,
                  validator: (value) {
                    try {
                      if (value == null || value.isEmpty) {
                        return 'Content is required';
                      }
                      Validators.validatePostBody(value);
                      return null;
                    } catch (e) {
                      return e.toString().replaceFirst('Exception: ', '');
                    }
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 24),

                // User ID field
                Text(
                  'User ID',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    hintText: 'Enter user ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'User ID is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'User ID must be a number';
                    }
                    return null;
                  },
                  enabled: !_isSubmitting,
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(widget.isEditMode ? 'Update' : 'Create'),
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

  /// Submits the form
  /// 
  /// Validates input and either creates or updates post
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final userId = int.parse(_userIdController.text.trim());

    if (widget.isEditMode) {
      // Update existing post
      _postBloc.add(
        UpdatePostEvent(
          id: widget.postToEdit!.id.toString(),
          title: title,
          body: body,
        ),
      );
    } else {
      // Create new post
      _postBloc.add(
        CreatePostEvent(
          title: title,
          body: body,
          userId: userId,
        ),
      );
    }
  }
}
