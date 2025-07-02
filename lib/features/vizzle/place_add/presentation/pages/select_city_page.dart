import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
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
      context.read<PlaceAddProvider>().loadCities();
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
            return const Center(
              child: CommonTextWidget(text: 'No data available', fontSize: 16),
            );
          }

          if (result.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppConstants.error,
                    size: 64,
                  ),
                  AppSpacing.verticalMD,
                  CommonTextWidget(
                    text: result.errorMessage ?? 'Something went wrong',
                    fontSize: 16,
                    align: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final cities = provider.cities!;
          if (_filteredCities.isEmpty && _searchController.text.isEmpty) {
            _filteredCities = cities.map((city) => city.name).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonTextWidget(
                      text: 'Where do you want to place your ad?',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.center,
                    ),
                    AppSpacing.verticalMD,
                    TextField(
                      controller: _searchController,
                      onChanged: _filterCities,
                      style: const TextStyle(color: AppConstants.white),
                      decoration: InputDecoration(
                        hintText: 'Search city',
                        hintStyle: TextStyle(
                          color: AppConstants.white.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppConstants.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: AppConstants.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredCities.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppConstants.white.withOpacity(0.1),
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final cityName = _filteredCities[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: CommonTextWidget(
                        text: cityName,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      onTap: () {
                        provider.selectCity(cityName);
                        Navigator.pop(context);
                      },
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
