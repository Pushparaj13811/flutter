import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/community/providers/community_provider.dart';

const _postCategories = [
  'Announcements',
  'Teaching Tips',
  'Learning Resources',
  'Exchange Requests',
  'Discussion',
  'Success Stories',
];

class CreatePostScreen extends ConsumerStatefulWidget {
  final String? circleId;
  final String? circleName;

  const CreatePostScreen({super.key, this.circleId, this.circleName});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<File> _selectedImages = [];
  File? _selectedVideo;
  String _selectedCategory = 'Discussion';
  bool _isSubmitting = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((f) => File(f.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  void _removeVideo() {
    setState(() {
      _selectedVideo = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final service = ref.read(communityFirestoreServiceProvider);
      final user = FirebaseAuth.instance.currentUser;
      final authorName = user?.displayName ?? 'Anonymous';
      final authorAvatar = user?.photoURL ?? '';

      // Upload media
      List<String> uploadedImageUrls = [];
      String? uploadedVideoUrl;

      if (_selectedImages.isNotEmpty) {
        uploadedImageUrls = await service.uploadPostMedia(_selectedImages);
      }

      if (_selectedVideo != null) {
        uploadedVideoUrl = await service.uploadPostVideo(_selectedVideo!);
      }

      // Determine media type
      String mediaType = 'text';
      if (uploadedVideoUrl != null) {
        mediaType = 'video';
      } else if (uploadedImageUrls.isNotEmpty) {
        mediaType = 'image';
      }

      // Create post data
      final postData = <String, dynamic>{
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'category': _selectedCategory,
        'tags': _tags,
        'images': uploadedImageUrls
            .map((url) => {'url': url, 'publicId': ''})
            .toList(),
        'videoUrl': uploadedVideoUrl,
        'mediaType': mediaType,
        'circle': widget.circleId,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
      };

      await service.createPost(postData);

      if (!mounted) return;

      // Invalidate providers to refresh
      ref.invalidate(discussionPostsProvider);

      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.circleName != null
              ? 'Post in ${widget.circleName}'
              : 'Create Post',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What do you want to discuss?',
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // Content
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Share your thoughts...',
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Content is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: _postCategories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // Tags
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: 'Tags',
                      hintText: 'Add a tag',
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: AppTextStyles.caption),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeTag(tag),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Media section
            Text('Media', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _pickImages,
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Images'),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _pickVideo,
                  icon: const Icon(Icons.videocam_outlined),
                  label: const Text('Video'),
                ),
              ],
            ),

            // Image previews
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppRadius.card),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: context.colors.destructive,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: context.colors.destructiveForeground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],

            // Video preview
            if (_selectedVideo != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.videocam,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _selectedVideo!.path.split('/').last,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: context.colors.destructive,
                      ),
                      onPressed: _removeVideo,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],

            // Loading indicator
            if (_isSubmitting) ...[
              const SizedBox(height: AppSpacing.xl),
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.sm),
                    Text('Uploading...'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
