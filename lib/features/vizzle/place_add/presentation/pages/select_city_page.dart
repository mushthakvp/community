import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/place_add_provider.dart';

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({super.key});

  @override
  State<SelectCityPage> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PlaceAddProvider>();
      provider.loadCities();
    });
  }

  void _filterCities(String query) {
    final provider = context.read<PlaceAddProvider>();
    final cities = provider.cities;
    if (cities != null) {
      setState(() {
        if (query.isEmpty) {
          _filteredCities = cities.map((city) => city.name).toList();
        } else {
          _filteredCities = cities
              .where(
                (city) => city.name.toLowerCase().contains(query.toLowerCase()),
              )
              .map((city) => city.name)
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Select City', showBackButton: true),
      body: Consumer<PlaceAddProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading cities...'),
            );
          }

          final result = provider.citiesResult;
          if (result == null) {
            return _buildEmptyState(provider);
          }

          if (result.isError) {
            return _buildErrorState(provider, result.errorMessage);
          }

          final cities = provider.cities!;
          if (_filteredCities.isEmpty && _searchController.text.isEmpty) {
            _filteredCities = cities.map((city) => city.name).toList();
          }

          return Column(
            children: [
              _buildHeader(),
              _buildSearchField(),
              Expanded(child: _buildCityList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: 'Where do you want to place your ad?',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: 'Select your city to continue',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: _filterCities,
        style: const TextStyle(color: AppConstants.white),
        decoration: InputDecoration(
          hintText: 'Search city',
          hintStyle: TextStyle(color: AppConstants.white.withOpacity(0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: AppConstants.white.withOpacity(0.5),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _filterCities('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppConstants.white.withOpacity(0.5),
                  ),
                )
              : null,
          filled: true,
          fillColor: AppConstants.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppConstants.appPrimaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityList() {
    if (_filteredCities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppConstants.white.withOpacity(0.3),
            ),
            AppSpacing.verticalMD,
            const CommonTextWidget(
              text: 'No cities found',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            AppSpacing.verticalSM,
            CommonTextWidget(
              text: 'Try searching with a different term',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCities.length,
      separatorBuilder: (context, index) => Divider(
        color: AppConstants.white.withOpacity(0.1),
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final cityName = _filteredCities[index];
        return _CityTile(
          cityName: cityName,
          onTap: () {
            final provider = context.read<PlaceAddProvider>();
            provider.selectCity(cityName);
            // Navigate to category selection
            context.push(RouteConstants.selectCategory);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(PlaceAddProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city,
            size: 80,
            color: AppConstants.white.withOpacity(0.3),
          ),
          AppSpacing.verticalMD,
          const CommonTextWidget(
            text: 'No cities available',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: 'Please try again later',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
          ),
          AppSpacing.verticalXL,
          ElevatedButton(
            onPressed: () => provider.loadCities(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PlaceAddProvider provider, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppConstants.error, size: 80),
          AppSpacing.verticalMD,
          const CommonTextWidget(
            text: 'Failed to load cities',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: errorMessage ?? 'Something went wrong',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
            align: TextAlign.center,
          ),
          AppSpacing.verticalXL,
          ElevatedButton(
            onPressed: () => provider.loadCities(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _CityTile extends StatelessWidget {
  final String cityName;
  final VoidCallback onTap;

  const _CityTile({required this.cityName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.location_city,
                  color: AppConstants.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextWidget(
                  text: cityName,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppConstants.appPrimaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
