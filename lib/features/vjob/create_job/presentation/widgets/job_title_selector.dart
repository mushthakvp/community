import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class JobTitleSelector extends StatefulWidget {
  const JobTitleSelector({super.key});

  @override
  State<JobTitleSelector> createState() => _JobTitleSelectorState();
}

class _JobTitleSelectorState extends State<JobTitleSelector> {
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Job Title',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CompositedTransformTarget(
              link: _layerLink,
              child: CommonTextField(
                controller: provider.titleController,
                hintText: 'Enter Job Title',
                validator: provider.validateTitle,
                onChanged: (value) => provider.setJobTitle(value),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (provider.titleController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => _createNewTitle(provider),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.appPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppConstants.black,
                            size: 16,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: AppConstants.white,
                      ),
                      onPressed: _toggleDropdown,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final provider = context.read<CreateJobProvider>();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            color: AppConstants.black,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: AppConstants.white.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: provider.jobTitles.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CommonTextWidget(
                        text: 'No job titles found',
                        color: AppConstants.white,
                        fontSize: 14,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: provider.jobTitles.length,
                      itemBuilder: (context, index) {
                        final title = provider.jobTitles[index];
                        return ListTile(
                          title: CommonTextWidget(
                            text: title.name,
                            color: AppConstants.white,
                            fontSize: 14,
                          ),
                          onTap: () {
                            provider.setJobTitle(title.name);
                            _closeDropdown();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isDropdownOpen = false);
    }
  }

  void _createNewTitle(CreateJobProvider provider) {
    final title = provider.titleController.text.trim();
    if (title.isNotEmpty) {
      provider.createJobTitle(title);
    }
  }
}
