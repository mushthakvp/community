import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';
import '../register_data_loader.dart';

class SmartLocationFields extends StatefulWidget {
  const SmartLocationFields({super.key});

  @override
  State<SmartLocationFields> createState() => _SmartLocationFieldsState();
}

class _SmartLocationFieldsState extends State<SmartLocationFields> {
  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _districts = [];
  String _lastProcessedCountry = '';
  String _selectedCountryName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSetCountryFromPhoneCode();
    });
  }

  void _autoSetCountryFromPhoneCode() {
    final authProvider = context.read<AuthProvider>();
    final dataProvider = RegisterDataProvider.of(context);
    if (dataProvider == null) return;

    // Map country codes to country names
    final countryCodeToName = {'IN': 'India', 'AE': 'United Arab Emirates'};

    final phoneCountryCode = authProvider.selectedCountryCode;
    final countryName = countryCodeToName[phoneCountryCode] ?? 'India';

    if (countryName != _lastProcessedCountry) {
      _lastProcessedCountry = countryName;
      _selectedCountryName = countryName;

      // Set country in auth provider without asking user
      authProvider.setLocation(
        country: countryName,
        countryCode: phoneCountryCode,
        onSuccess: (String name) {
          log("Auto-selected country from phone code: $name");
          _loadStatesForCountry(countryName, dataProvider);
        },
      );
    }
  }

  void _loadStatesForCountry(
    String countryName,
    RegisterDataProvider dataProvider,
  ) {
    final countries = dataProvider.countries;
    final matchingCountry = countries.firstWhere(
      (country) => country['country'] == countryName,
      orElse: () => <String, dynamic>{},
    );

    if (matchingCountry.isNotEmpty && mounted) {
      setState(() {
        _states = (matchingCountry['states'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        _districts.clear();
      });
      log("Loaded ${_states.length} states for $countryName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Monitor for country code changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentCountryCode = authProvider.selectedCountryCode;
          final countryCodeToName = {
            'IN': 'India',
            'AE': 'United Arab Emirates',
          };
          final expectedCountryName =
              countryCodeToName[currentCountryCode] ?? 'India';

          if (expectedCountryName != _lastProcessedCountry) {
            _autoSetCountryFromPhoneCode();
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show selected country (read-only, for user awareness)
            _buildCountryDisplay(),
            const SizedBox(height: 16),

            // State selection
            _buildStateField(authProvider),

            if (_districts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDistrictField(authProvider),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCountryDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppConstants.appPrimaryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CommonTextWidget(
              text:
                  'Country: $_selectedCountryName (auto-selected from phone number)',
              fontSize: 12,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(text: authProvider.selectedState),
      hintText: 'Select State *',
      readOnly: true,
      onTap: _states.isEmpty ? null : () => _showStatePicker(authProvider),
      prefixIcon: const Icon(
        Icons.location_on_outlined,
        color: AppConstants.white,
      ),
      suffixIcon: _states.isEmpty
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.arrow_drop_down, color: AppConstants.white),
      validator: (value) => authProvider.selectedState.isEmpty
          ? 'Please select your state'
          : null,
    );
  }

  Widget _buildDistrictField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(text: authProvider.selectedDistrict),
      hintText: 'Select District (Optional)',
      readOnly: true,
      onTap: () => _showDistrictPicker(authProvider),
      prefixIcon: const Icon(
        Icons.location_city_outlined,
        color: AppConstants.white,
      ),
      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppConstants.white),
    );
  }

  void _showStatePicker(AuthProvider authProvider) {
    if (_states.isEmpty) return;

    _showLocationPicker(
      context: context,
      title: 'Select State',
      searchHint: 'Search state...',
      items: _states,
      displayKey: 'state',
      onSelected: (state) {
        final stateName = state['state'] as String;
        final stateCode = state['code'] as String;
        authProvider.setLocation(state: stateName, stateCode: stateCode);
        _loadDistrictsForState(state);
      },
      selectedValue: authProvider.selectedState,
    );
  }

  void _showDistrictPicker(AuthProvider authProvider) {
    if (_districts.isEmpty) return;

    _showLocationPicker(
      context: context,
      title: 'Select District',
      searchHint: 'Search district...',
      items: _districts,
      displayKey: 'name',
      onSelected: (district) {
        final districtName = district['name'] as String;
        authProvider.setLocation(district: districtName);
      },
      selectedValue: authProvider.selectedDistrict,
    );
  }

  void _showLocationPicker({
    required BuildContext context,
    required String title,
    required String searchHint,
    required List<Map<String, dynamic>> items,
    required String displayKey,
    required Function(Map<String, dynamic>) onSelected,
    required String selectedValue,
  }) {
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
            List<Map<String, dynamic>> filteredItems = items
                .where(
                  (item) => (item[displayKey] as String).toLowerCase().contains(
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
                  CommonTextWidget(
                    text: title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  const SizedBox(height: 20),
                  if (items.length > 5) ...[
                    CommonTextField(
                      controller: searchController,
                      hintText: searchHint,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppConstants.white,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemName = item[displayKey] as String;
                        return ListTile(
                          title: CommonTextWidget(
                            text: itemName,
                            fontSize: 16,
                            color: AppConstants.white,
                          ),
                          onTap: () {
                            onSelected(item);
                            Navigator.pop(context);
                          },
                          trailing: selectedValue == itemName
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

  void _loadDistrictsForState(Map<String, dynamic> state) {
    if (mounted) {
      setState(() {
        _districts = (state['district'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
      });
      log("Loaded ${_districts.length} districts for ${state['state']}");
    }
  }
}
