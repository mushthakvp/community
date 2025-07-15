import 'package:flutter/material.dart';

class CommunityFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const CommunityFormWidget({
    super.key,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Community Name Field
        _buildFieldLabel(context, 'Community Name *'),
        const SizedBox(height: 8),
        _buildNameField(context),
        const SizedBox(height: 20),

        // Description Field
        _buildFieldLabel(context, 'Description (Optional)'),
        const SizedBox(height: 8),
        _buildDescriptionField(context),
      ],
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: 'Enter community name',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.group,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a community name';
        }
        if (value.trim().length < 3) {
          return 'Community name must be at least 3 characters';
        }
        if (value.trim().length > 50) {
          return 'Community name must not exceed 50 characters';
        }
        // Check for inappropriate characters
        if (value.contains(RegExp(r'[<>"/\\|?*]'))) {
          return 'Community name contains invalid characters';
        }
        return null;
      },
      maxLength: 50,
      buildCounter:
          (context, {required currentLength, required isFocused, maxLength}) {
            return Text(
              '$currentLength/${maxLength ?? 50}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            );
          },
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Tell people what your community is about...',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 12, left: 12),
          child: Icon(
            Icons.description,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      validator: (value) {
        if (value != null && value.trim().isNotEmpty) {
          if (value.trim().length < 10) {
            return 'Description must be at least 10 characters if provided';
          }
          if (value.trim().length > 500) {
            return 'Description must not exceed 500 characters';
          }
        }
        return null;
      },
      maxLength: 500,
      buildCounter:
          (context, {required currentLength, required isFocused, maxLength}) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Help people understand what your community is about',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$currentLength/${maxLength ?? 500}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
