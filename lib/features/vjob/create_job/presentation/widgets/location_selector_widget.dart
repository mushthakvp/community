import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class LocationSelectorWidget extends StatefulWidget {
  const LocationSelectorWidget({super.key});

  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {
  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _states = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/state_and_district.json',
      );
      final List<dynamic> data = json.decode(response);

      setState(() {
        _countries = data.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<CreateJobProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Location'),
            const SizedBox(height: 8),
            _buildCountryField(provider),
            const SizedBox(height: 16),
            _buildStateField(provider),
          ],
        );
      },
    );
  }

  Widget _buildCountryField(CreateJobProvider provider) {
    return GestureDetector(
      onTap: () => _showCountrySelector(provider),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.public, color: AppConstants.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: CommonTextWidget(
                text: provider.selectedCountry.isEmpty
                    ? 'Select Country'
                    : provider.selectedCountry,
                fontSize: 14,
                color: provider.selectedCountry.isEmpty
                    ? AppConstants.white.withOpacity(0.6)
                    : AppConstants.white,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppConstants.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateField(CreateJobProvider provider) {
    return GestureDetector(
      onTap: provider.selectedCountry.isEmpty
          ? null
          : () => _showStateSelector(provider),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: provider.selectedCountry.isEmpty
                  ? AppConstants.white.withOpacity(0.5)
                  : AppConstants.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonTextWidget(
                text: provider.selectedState.isEmpty
                    ? 'Select State'
                    : provider.selectedState,
                fontSize: 14,
                color: provider.selectedCountry.isEmpty
                    ? AppConstants.white.withOpacity(0.4)
                    : provider.selectedState.isEmpty
                    ? AppConstants.white.withOpacity(0.6)
                    : AppConstants.white,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: provider.selectedCountry.isEmpty
                  ? AppConstants.white.withOpacity(0.5)
                  : AppConstants.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return CommonTextWidget(
      text: label,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppConstants.white,
    );
  }

  void _showCountrySelector(CreateJobProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CountrySelector(
        countries: _countries,
        onCountrySelected: (country) {
          provider.setCountry(country['country'], country['code']);
          // Load states for selected country
          _loadStatesForCountry(country);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStateSelector(CreateJobProvider provider) {
    if (_states.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No states available for selected country'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _StateSelector(
        states: _states,
        onStateSelected: (state) {
          provider.setState(state['state'], state['code']);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _loadStatesForCountry(Map<String, dynamic> country) {
    setState(() {
      _states = List<Map<String, dynamic>>.from(country['states'] ?? []);
    });
  }
}

class _CountrySelector extends StatefulWidget {
  final List<Map<String, dynamic>> countries;
  final Function(Map<String, dynamic>) onCountrySelected;

  const _CountrySelector({
    required this.countries,
    required this.onCountrySelected,
  });

  @override
  State<_CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<_CountrySelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries
            .where(
              (country) => country['country'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppConstants.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const CommonTextWidget(
                  text: 'Select Country',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.white),
                ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: CommonTextField(
              controller: _searchController,
              hintText: 'Search countries...',
              prefixIcon: const Icon(Icons.search, color: AppConstants.white),
              onChanged: _filterCountries,
            ),
          ),
          // Countries list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppConstants.appPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.public,
                      color: AppConstants.appPrimaryColor,
                      size: 20,
                    ),
                  ),
                  title: CommonTextWidget(
                    text: country['country'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.white,
                  ),
                  subtitle: CommonTextWidget(
                    text: 'Code: ${country['code']}',
                    fontSize: 12,
                    color: AppConstants.white.withOpacity(0.7),
                  ),
                  onTap: () => widget.onCountrySelected(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StateSelector extends StatefulWidget {
  final List<Map<String, dynamic>> states;
  final Function(Map<String, dynamic>) onStateSelected;

  const _StateSelector({required this.states, required this.onStateSelected});

  @override
  State<_StateSelector> createState() => _StateSelectorState();
}

class _StateSelectorState extends State<_StateSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredStates = [];

  @override
  void initState() {
    super.initState();
    _filteredStates = widget.states;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStates(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStates = widget.states;
      } else {
        _filteredStates = widget.states
            .where(
              (state) => state['state'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppConstants.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const CommonTextWidget(
                  text: 'Select State',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.white),
                ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: CommonTextField(
              controller: _searchController,
              hintText: 'Search states...',
              prefixIcon: const Icon(Icons.search, color: AppConstants.white),
              onChanged: _filterStates,
            ),
          ),
          // States list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredStates.length,
              itemBuilder: (context, index) {
                final state = _filteredStates[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppConstants.appPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppConstants.appPrimaryColor,
                      size: 20,
                    ),
                  ),
                  title: CommonTextWidget(
                    text: state['state'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.white,
                  ),
                  subtitle: CommonTextWidget(
                    text: 'Code: ${state['code']}',
                    fontSize: 12,
                    color: AppConstants.white.withOpacity(0.7),
                  ),
                  onTap: () => widget.onStateSelected(state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
