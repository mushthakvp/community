import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/inkwell_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/add_edit_provider.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddEditProvider>().getCitiesAndCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: "Select City", showBackButton: true),
      body: Consumer<AddEditProvider>(
        builder: (context, provider, child) {
          if (provider.state == AddEditState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.appPrimaryColor,
              ),
            );
          }

          return Column(
            children: [
              // Search Section
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    const CommonTextWidget(
                      text: "Select a City",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text: "Where do you want to place your ad?",
                      fontSize: 14,
                      color: AppConstants.white.withOpacity(0.6),
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CommonTextField(
                      controller: _searchController,
                      hintText: "Search city",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppConstants.white,
                      ),
                      onChanged: (value) {
                        provider.searchCities(value);
                      },
                    ),
                  ],
                ),
              ),

              // Cities List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  itemCount: provider.cityList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppConstants.white.withOpacity(0.1),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final city = provider.cityList[index];

                    return CommonInkWell(
                      onTap: () {
                        provider.selectCity(city);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: AppConstants.white.withOpacity(0.6),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CommonTextWidget(
                                text: city,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppConstants.white.withOpacity(0.4),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
