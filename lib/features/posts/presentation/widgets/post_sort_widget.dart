import 'package:flutter/material.dart';
import 'package:post_app/features/posts/domain/entities/post_sort_type.dart';

/// Bottom sheet for selecting post sort type
/// 
/// Displays available sorting options and returns selected sort type
class PostSortBottomSheet extends StatelessWidget {
  const PostSortBottomSheet({
    required this.currentSortType,
    required this.onSortSelected,
    super.key,
  });

  /// Currently selected sort type
  final PostSortType currentSortType;

  /// Callback when sort type is selected
  final Function(PostSortType) onSortSelected;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sort Posts By',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              itemCount: PostSortType.values.length,
              itemBuilder: (context, index) {
                final sortType = PostSortType.values[index];
                final isSelected = sortType == currentSortType;

                return ListTile(
                  title: Text(sortType.displayName),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  selected: isSelected,
                  onTap: () {
                    onSortSelected(sortType);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      );
}

/// Dialog for selecting post sort type
/// 
/// Displays available sorting options in a dialog format
class PostSortDialog extends StatelessWidget {
  const PostSortDialog({
    required this.currentSortType,
    required this.onSortSelected,
    super.key,
  });

  /// Currently selected sort type
  final PostSortType currentSortType;

  /// Callback when sort type is selected
  final Function(PostSortType) onSortSelected;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Sort Posts By'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: PostSortType.values.length,
            itemBuilder: (context, index) {
              final sortType = PostSortType.values[index];
              final isSelected = sortType == currentSortType;

              return RadioListTile<PostSortType>(
                title: Text(sortType.displayName),
                value: sortType,
                groupValue: currentSortType,
                onChanged: (value) {
                  if (value != null) {
                    onSortSelected(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
      );
}
