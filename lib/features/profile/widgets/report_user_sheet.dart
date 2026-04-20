// Report user bottom sheet

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';

class ReportUserSheet extends StatefulWidget {
  const ReportUserSheet({super.key, required this.userId});

  final String userId;

  @override
  State<ReportUserSheet> createState() => _ReportUserSheetState();
}

class _ReportUserSheetState extends State<ReportUserSheet> {
  static const List<String> _reasons = [
    'Spam',
    'Harassment',
    'Inappropriate Content',
    'Fake Profile',
    'Other',
  ];

  String? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason')),
      );
      return;
    }

    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'reporter': FirebaseAuth.instance.currentUser!.uid,
        'reportedUser': widget.userId,
        'reason': _selectedReason!.toLowerCase().replaceAll(' ', '_'),
        'description': description,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted. Thank you.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            'Report User',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Reason dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedReason,
            decoration: const InputDecoration(
              labelText: 'Reason',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            hint: const Text('Select a reason'),
            items: _reasons
                .map(
                  (reason) => DropdownMenuItem<String>(
                    value: reason,
                    child: Text(reason, style: AppTextStyles.bodyMedium),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedReason = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Description text field
          AppTextField(
            hint: 'Describe the issue...',
            controller: _descriptionController,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit button
          AppButton.primary(
            label: 'Submit Report',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
