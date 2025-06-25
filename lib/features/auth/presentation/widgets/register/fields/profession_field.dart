import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';
import '../register_data_loader.dart';

class ProfessionField extends StatelessWidget {
  const ProfessionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return CommonTextField(
          controller: TextEditingController(
            text: authProvider.selectedProfession,
          ),
          hintText: 'Select Profession *',
          readOnly: true,
          onTap: () => _showProfessionPicker(context, authProvider),
          prefixIcon: const Icon(Icons.work_outline, color: AppConstants.white),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppConstants.white,
          ),
          validator: (value) => authProvider.selectedProfession.isEmpty
              ? 'Please select your profession'
              : null,
        );
      },
    );
  }

  void _showProfessionPicker(BuildContext context, AuthProvider authProvider) {
    final dataProvider = RegisterDataProvider.of(context);
    if (dataProvider == null) return;

    final professions = dataProvider.professions;
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<String> filteredProfessions = professions
                .where(
                  (profession) => profession.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
                )
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildHandle(),
                  const SizedBox(height: 20),
                  const CommonTextWidget(
                    text: 'Select Profession',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: searchController,
                    hintText: 'Search profession...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.white,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredProfessions.length,
                      itemBuilder: (context, index) {
                        final profession = filteredProfessions[index];
                        return ListTile(
                          title: CommonTextWidget(
                            text: profession,
                            fontSize: 16,
                            color: AppConstants.white,
                          ),
                          onTap: () {
                            authProvider.setProfession(profession);
                            Navigator.pop(context);
                          },
                          trailing:
                              authProvider.selectedProfession == profession
                              ? const Icon(
                                  Icons.check,
                                  color: AppConstants.appPrimaryColor,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
