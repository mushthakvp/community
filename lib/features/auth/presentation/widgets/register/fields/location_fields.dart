import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';
import '../register_data_loader.dart';

class LocationFields extends StatefulWidget {
  const LocationFields({super.key});

  @override
  State<LocationFields> createState() => _LocationFieldsState();
}

class _LocationFieldsState extends State<LocationFields> {
  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _districts = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            _buildCountryField(authProvider),
            const SizedBox(height: 20),
            _buildStateField(authProvider),
            if (_districts.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildDistrictField(authProvider),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCountryField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(text: authProvider.selectedCountry),
      hintText: 'Select Country *',
      readOnly: true,
      onTap: () => _showCountryPicker(authProvider),
      prefixIcon: const Icon(Icons.public, color: AppConstants.white),
      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppConstants.white),
      validator: (value) => authProvider.selectedCountry.isEmpty
          ? 'Please select your country'
          : null,
    );
  }

  Widget _buildStateField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(text: authProvider.selectedState),
      hintText: 'Select State *',
      readOnly: true,
      onTap: authProvider.selectedCountry.isEmpty
          ? null
          : () => _showStatePicker(authProvider),
      prefixIcon: const Icon(
        Icons.location_on_outlined,
        color: AppConstants.white,
      ),
      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppConstants.white),
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

  void _showCountryPicker(AuthProvider authProvider) {
    final dataProvider = RegisterDataProvider.of(context);
    if (dataProvider == null) return;

    final countries = dataProvider.countries;
    final searchController = TextEditingController();

    _showLocationPicker(
      context: context,
      title: 'Select Country',
      searchHint: 'Search country...',
      items: countries,
      displayKey: 'country',
      searchController: searchController,
      onSelected: (country) {
        final countryName = country['country'] as String;
        authProvider.setLocation(country: countryName);
        _loadStatesForCountry(country);
      },
      selectedValue: authProvider.selectedCountry,
    );
  }

  void _showStatePicker(AuthProvider authProvider) {
    if (_states.isEmpty) return;

    final searchController = TextEditingController();

    _showLocationPicker(
      context: context,
      title: 'Select State',
      searchHint: 'Search state...',
      items: _states,
      displayKey: 'state',
      searchController: searchController,
      onSelected: (state) {
        final stateName = state['state'] as String;
        authProvider.setLocation(state: stateName);
        _loadDistrictsForState(state);
      },
      selectedValue: authProvider.selectedState,
    );
  }

  void _showDistrictPicker(AuthProvider authProvider) {
    if (_districts.isEmpty) return;

    final searchController = TextEditingController();

    _showLocationPicker(
      context: context,
      title: 'Select District',
      searchHint: 'Search district...',
      items: _districts,
      displayKey: 'name',
      searchController: searchController,
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
    required TextEditingController searchController,
    required Function(Map<String, dynamic>) onSelected,
    required String selectedValue,
  }) {
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

  void _loadStatesForCountry(Map<String, dynamic> country) {
    setState(() {
      _states = (country['states'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      _districts.clear();
    });
  }

  void _loadDistrictsForState(Map<String, dynamic> state) {
    setState(() {
      _districts = (state['district'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    });
  }
}
