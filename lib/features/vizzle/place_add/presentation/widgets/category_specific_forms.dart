import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/place_add_provider.dart';
import 'bottom_sheet_selector.dart';
import 'form_field_widget.dart';

class MotorSpecificFields extends StatelessWidget {
  final String category;

  const MotorSpecificFields({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category == "Cars" || category == "Motorcycles") ...[
              CustomFormField(
                controller: provider.modelController,
                labelText: 'Make/Model',
                hintText: 'Enter make and model',
              ),
              AppSpacing.verticalMD,
            ],

            if (category != "Auto Accessories & Parts") ...[
              CustomFormField(
                controller: provider.yearController,
                labelText: 'Year',
                hintText: 'Enter year',
                keyboardType: TextInputType.number,
              ),
              AppSpacing.verticalMD,

              CustomFormField(
                controller: provider.kilometerController,
                labelText: 'Kilometers',
                hintText: 'Enter kilometers',
                keyboardType: TextInputType.number,
              ),
              AppSpacing.verticalMD,
            ],

            // Fuel Type
            if (category != "Auto Accessories & Parts") ...[
              CustomFormField(
                controller: provider.fuelTypeController,
                labelText: 'Fuel Type',
                hintText: 'Select fuel type',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Fuel Type',
                  provider.fuelTypeList,
                  provider.selectedFuelTypeItem,
                  provider.selectFueltypeFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Color
            if (category != "Auto Accessories & Parts") ...[
              CustomFormField(
                controller: provider.colorController,
                labelText: 'Color',
                hintText: 'Select color',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Color',
                  provider.colorTypeList,
                  provider.selectedColorTypeItem,
                  provider.selectColorTypeFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Transmission (Cars only)
            if (category == "Cars") ...[
              CustomFormField(
                controller: provider.transmissionController,
                labelText: 'Transmission Type',
                hintText: 'Select transmission',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Transmission Type',
                  provider.transmissionTypeList,
                  provider.selectedTransmissionTypeItem,
                  provider.selectTransmissionTypeFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Usage
            CustomFormField(
              controller: provider.usageController,
              labelText: 'Usage',
              hintText: 'Select usage',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Usage',
                provider.usageTypeList,
                provider.selectedUsageTypeItem,
                provider.selectUsageTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Condition (for Auto Accessories & Parts)
            if (category == "Auto Accessories & Parts") ...[
              CustomFormField(
                controller: provider.conditionController,
                labelText: 'Condition',
                hintText: 'Select condition',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Condition',
                  provider.conditionTypeList,
                  provider.selectedConditionTypeItem,
                  provider.selectConditionTypeFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Seller Type
            CustomFormField(
              controller: provider.sellerTypeController,
              labelText: 'Seller Type',
              hintText: 'Select seller type',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Seller Type',
                provider.sellerTypeList,
                provider.selectSellerTypeItem,
                provider.selectSellerTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        );
      },
    );
  }

  void _showSelectionBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    String selectedItem,
    Function(String) onSelect,
  ) {
    BottomSheetSelector.show(
      context,
      title: title,
      items: items,
      selectedItem: selectedItem,
      onItemSelected: onSelect,
    );
  }
}

class ElectronicsSpecificFields extends StatelessWidget {
  final String category;

  const ElectronicsSpecificFields({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age
            CustomFormField(
              controller: provider.ageController,
              labelText: 'Age',
              hintText: 'Select age',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Age',
                provider.ageTypeList,
                provider.selectedAgeTypeItem,
                provider.selectAgeTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Usage
            CustomFormField(
              controller: provider.usageController,
              labelText: 'Usage',
              hintText: 'Select usage',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Usage',
                provider.usageTypeList,
                provider.selectedUsageTypeItem,
                provider.selectUsageTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Condition
            CustomFormField(
              controller: provider.conditionController,
              labelText: 'Condition',
              hintText: 'Select condition',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Condition',
                provider.conditionTypeList,
                provider.selectedConditionTypeItem,
                provider.selectConditionTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Seller Type
            CustomFormField(
              controller: provider.sellerTypeController,
              labelText: 'Seller Type',
              hintText: 'Select seller type',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Seller Type',
                provider.sellerTypeList,
                provider.selectSellerTypeItem,
                provider.selectSellerTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Warranty (Computers & Mobile)
            if (category == "Computers & Networking" ||
                category == "Mobile Phones & Tablets") ...[
              CustomFormField(
                controller: provider.warrantyController,
                labelText: 'Warranty',
                hintText: 'Select warranty',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Warranty',
                  provider.warrantyList,
                  provider.selectedWarrantyItem,
                  provider.selectWarrantyFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Brand
            CustomFormField(
              controller: provider.brandController,
              labelText: 'Brand',
              hintText: 'Select brand',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Brand',
                provider.brandList,
                provider.selectedBrandItem,
                provider.selectBrandFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Memory/RAM (Computers & Mobile)
            if (category == "Computers & Networking" ||
                category == "Mobile Phones & Tablets") ...[
              CustomFormField(
                controller: provider.memoryRamController,
                labelText: 'Memory (RAM)',
                hintText: 'Select memory',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Memory (RAM)',
                  provider.memoryList,
                  provider.selectedMemoryItem,
                  provider.selectMemoryFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],

            // Processor (Computers only)
            if (category == "Computers & Networking") ...[
              CustomFormField(
                controller: provider.processorController,
                labelText: 'Processor Speed',
                hintText: 'Select processor speed',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Processor Speed',
                  provider.processorSpeedList,
                  provider.selectedProcessorSpeedItem,
                  provider.selectProcessorSpeedFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,

              CustomFormField(
                controller: provider.hardDriveController,
                labelText: 'Hard Drive/SSD',
                hintText: 'Select storage',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Hard Drive/SSD',
                  provider.hardDriveList,
                  provider.selectedHardDriveItem,
                  provider.selectHardDriveFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,
            ],
          ],
        );
      },
    );
  }

  void _showSelectionBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    String selectedItem,
    Function(String) onSelect,
  ) {
    BottomSheetSelector.show(
      context,
      title: title,
      items: items,
      selectedItem: selectedItem,
      onItemSelected: onSelect,
    );
  }
}

class MobileSpecificFields extends StatelessWidget {
  const MobileSpecificFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model
            CustomFormField(
              controller: provider.modelController,
              labelText: 'Model',
              hintText: 'Enter model',
            ),
            AppSpacing.verticalMD,

            // Color
            CustomFormField(
              controller: provider.colorController,
              labelText: 'Color',
              hintText: 'Select color',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Color',
                provider.colorTypeList,
                provider.selectedColorTypeItem,
                provider.selectColorTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Damage Details (Multi-select)
            _buildDamageDetailsSection(provider),
            AppSpacing.verticalMD,

            // Battery Health
            CustomFormField(
              controller: provider.batteryPercentageController,
              labelText: 'Battery Health',
              hintText: 'Select battery health',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Battery Health',
                provider.batteryHealthTypeList,
                provider.selectedBatteryHealthTypeItem,
                provider.selectBatteryHealthTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Accompaniments (Multi-select)
            _buildAccompanimentsSection(provider),
            AppSpacing.verticalMD,

            // Carrier Lock
            CustomFormField(
              controller: provider.carrierLockController,
              labelText: 'Carrier Lock',
              hintText: 'Select carrier lock',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Carrier Lock',
                provider.selectedCarrierLockItemList,
                provider.selectedCarrierLockItem,
                provider.selectCarrierLockFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // IMEI Number
            CustomFormField(
              controller: provider.imeiNumberController,
              labelText: 'IMEI Number',
              hintText: 'Enter IMEI number',
            ),
            AppSpacing.verticalMD,

            // Storage Capacity
            CustomFormField(
              controller: provider.storageCapacityController,
              labelText: 'Storage Capacity',
              hintText: 'Select storage capacity',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Storage Capacity',
                provider.storageCapacityTypeItemForMobileList,
                provider.selectedStorageCapacityTypeItemForMobile,
                provider.selectStorageCapacityTypeItemForMobileTypeFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDamageDetailsSection(PlaceAddProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonTextWidget(
                  text: 'Damage Details',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                CommonTextWidget(
                  text: 'Optional',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: provider.damageDetailsList.length,
            itemBuilder: (context, index) {
              final item = provider.damageDetailsList[index];
              final isSelected = provider.selectedDamageDetailsItem.contains(
                item,
              );

              return CheckboxListTile(
                title: CommonTextWidget(text: item, fontSize: 12, maxLines: 1),
                value: isSelected,
                onChanged: (value) => provider.selectDamageDetailsFn(item),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccompanimentsSection(PlaceAddProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonTextWidget(
                  text: 'Accompaniments',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                CommonTextWidget(
                  text: 'Optional',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: provider.accompanimentsList.length,
            itemBuilder: (context, index) {
              final item = provider.accompanimentsList[index];
              final isSelected = provider.selectedAccompanimentsItem.contains(
                item,
              );

              return CheckboxListTile(
                title: CommonTextWidget(text: item, fontSize: 12, maxLines: 1),
                value: isSelected,
                onChanged: (value) => provider.selectAccompanimentsFn(item),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSelectionBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    String selectedItem,
    Function(String) onSelect,
  ) {
    BottomSheetSelector.show(
      context,
      title: title,
      items: items,
      selectedItem: selectedItem,
      onItemSelected: onSelect,
    );
  }
}

class PropertySpecificFields extends StatelessWidget {
  final String propertyType;

  const PropertySpecificFields({super.key, required this.propertyType});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Size
            CustomFormField(
              controller: provider.landSizeController,
              labelText: 'Size of Property',
              hintText: 'Enter size',
            ),
            AppSpacing.verticalMD,

            if (propertyType != "Land") ...[
              // Bedrooms
              CustomFormField(
                controller: provider.landBedroomController,
                labelText: 'Bedrooms',
                hintText: 'Select bedrooms',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Bedrooms',
                  provider.bedroomNumbers,
                  provider.totalBedRoomNumbers,
                  provider.bedRoomNumbers,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,

              // Bathrooms
              CustomFormField(
                controller: provider.landBathroomController,
                labelText: 'Bathrooms',
                hintText: 'Select bathrooms',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Bathrooms',
                  provider.bathroomNumbers,
                  provider.totalBathRoomNumbers,
                  provider.bathroomNumbersFn,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,

              // Furnished Status
              CustomFormField(
                controller: provider.landFurnishedController,
                labelText: 'Is it Furnished?',
                hintText: 'Select furnished status',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Furnished Status',
                  provider.furnishedStatusList,
                  provider.furnishedStatus,
                  provider.addFurnishedStatus,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,

              // Annual Community Fee
              CustomFormField(
                controller: provider.landAnnualFeeController,
                labelText: 'Annual Community Fee',
                hintText: 'Enter annual fee (Optional)',
                keyboardType: TextInputType.number,
              ),
              AppSpacing.verticalMD,

              // Maintenance Fee
              CustomFormField(
                controller: provider.landMaintenanceFeeController,
                labelText: 'Maintenance Fee',
                hintText: 'Enter maintenance fee (Optional)',
                keyboardType: TextInputType.number,
              ),
              AppSpacing.verticalMD,
            ],

            // Property Reference ID
            CustomFormField(
              controller: provider.landPropertyReferenceIdController,
              labelText: 'Property Reference ID',
              hintText: 'Enter reference ID (Optional)',
            ),
            AppSpacing.verticalMD,

            // Buyer Transfer Fee
            CustomFormField(
              controller: provider.landBuyerTransferFee,
              labelText: 'Buyer Transfer Fee',
              hintText: 'Enter buyer fee (Optional)',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.verticalMD,

            // Seller Transfer Fee
            CustomFormField(
              controller: provider.landSellerTransferFee,
              labelText: 'Seller Transfer Fee',
              hintText: 'Enter seller fee (Optional)',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.verticalMD,

            // Listed By
            CustomFormField(
              controller: provider.landListedByController,
              labelText: 'Listed By',
              hintText: 'Select who listed',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Listed By',
                provider.landListedByList,
                provider.landListedBy,
                provider.addLandListedBy,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            if (propertyType == "Land") ...[
              // Zoned For (Land only)
              CustomFormField(
                controller: provider.landZoneController,
                labelText: 'Zoned For',
                hintText: 'Select zone type',
                readOnly: true,
                onTap: () => _showSelectionBottomSheet(
                  context,
                  'Zoned For',
                  provider.landZoneList,
                  provider.landZone,
                  provider.addLandZone,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              AppSpacing.verticalMD,

              // Approved Build Area
              CustomFormField(
                controller: provider.landApproveBuildArea,
                labelText: 'Approved Build Area',
                hintText: 'Enter build area (Optional)',
              ),
              AppSpacing.verticalMD,
            ],

            // Occupancy Status
            CustomFormField(
              controller: provider.landOccupancyController,
              labelText: 'Occupancy Status',
              hintText: 'Select occupancy',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Occupancy Status',
                provider.occupancyStatusList,
                provider.occupancyStatus,
                provider.addOccupancyStatus,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        );
      },
    );
  }

  void _showSelectionBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    String selectedItem,
    Function({required String value}) onSelect,
  ) {
    BottomSheetSelector.show(
      context,
      title: title,
      items: items,
      selectedItem: selectedItem,
      onItemSelected: (value) => onSelect(value: value),
    );
  }
}

class RentSpecificFields extends StatelessWidget {
  const RentSpecificFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YouTube URL
            CustomFormField(
              controller: provider.youtubeUrlController,
              labelText: 'YouTube URL',
              hintText: 'Enter YouTube URL (Optional)',
            ),
            AppSpacing.verticalMD,

            // Size
            CustomFormField(
              controller: provider.landSizeController,
              labelText: 'Size',
              hintText: 'Enter property size',
            ),
            AppSpacing.verticalMD,

            // Bedrooms
            CustomFormField(
              controller: provider.landBedroomController,
              labelText: 'Bedrooms',
              hintText: 'Select bedrooms',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Bedrooms',
                provider.bedroomNumbers,
                provider.totalBedRoomNumbers,
                provider.bedRoomNumbers,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Bathrooms
            CustomFormField(
              controller: provider.landBathroomController,
              labelText: 'Bathrooms',
              hintText: 'Select bathrooms (Optional)',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Bathrooms',
                provider.bathroomNumbers,
                provider.totalBathRoomNumbers,
                provider.bathroomNumbersFn,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Furnished Status
            CustomFormField(
              controller: provider.landFurnishedController,
              labelText: 'Is it Furnished?',
              hintText: 'Select furnished status (Optional)',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Furnished Status',
                provider.furnishedStatusList,
                provider.furnishedStatus,
                provider.addFurnishedStatus,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Rent is Paid
            CustomFormField(
              controller: provider.rentIsPaidController,
              labelText: 'Rent is Paid',
              hintText: 'Select rent status (Optional)',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Rent Status',
                provider.isItFurnished,
                provider.rentIsPaidStatus,
                provider.addRentIsPaidStatus,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Property Reference ID
            CustomFormField(
              controller: provider.rentPropertyReferenceIdController,
              labelText: 'Property Reference ID',
              hintText: 'Enter reference ID (Optional)',
            ),
            AppSpacing.verticalMD,

            // Minimum Contract Period
            CustomFormField(
              controller: provider.rentMinimumContractPeriodController,
              labelText: 'Min Contract Period (Months)',
              hintText: 'Enter contract period (Optional)',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.verticalMD,

            // Notice Period
            CustomFormField(
              controller: provider.noticePeriodController,
              labelText: 'Notice Period',
              hintText: 'Enter notice period (Optional)',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.verticalMD,

            // Maintenance Fee
            CustomFormField(
              controller: provider.landMaintenanceFeeController,
              labelText: 'Maintenance Fee',
              hintText: 'Enter maintenance fee (Optional)',
              keyboardType: TextInputType.number,
            ),
            AppSpacing.verticalMD,

            // Occupancy Status
            CustomFormField(
              controller: provider.landOccupancyController,
              labelText: 'Occupancy Status',
              hintText: 'Select occupancy status',
              readOnly: true,
              onTap: () => _showSelectionBottomSheet(
                context,
                'Occupancy Status',
                provider.occupancyStatusList,
                provider.occupancyStatus,
                provider.addOccupancyStatus,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            AppSpacing.verticalMD,

            // Building
            CustomFormField(
              controller: provider.rentBuildingController,
              labelText: 'Building',
              hintText: 'Enter building name (Optional)',
            ),
            AppSpacing.verticalMD,

            // Rent Extras
            _buildRentExtrasSection(provider),
          ],
        );
      },
    );
  }

  Widget _buildRentExtrasSection(PlaceAddProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Extras',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        AppSpacing.verticalMD,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: provider.rentExtras.length,
          itemBuilder: (context, index) {
            final item = provider.rentExtras[index];
            return CheckboxListTile(
              title: CommonTextWidget(text: item, fontSize: 12, maxLines: 2),
              value: provider.isSelected(item),
              onChanged: (selected) => provider.toggleSelection(item),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            );
          },
        ),
      ],
    );
  }

  void _showSelectionBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
    String selectedItem,
    Function({required String value}) onSelect,
  ) {
    BottomSheetSelector.show(
      context,
      title: title,
      items: items,
      selectedItem: selectedItem,
      onItemSelected: (value) => onSelect(value: value),
    );
  }
}

class FarmFreshSpecificFields extends StatelessWidget {
  const FarmFreshSpecificFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
              controller: provider.farmFreshQuantityController,
              labelText: 'Quantity in Kg',
              hintText: 'Enter quantity',
              keyboardType: TextInputType.number,
            ),
          ],
        );
      },
    );
  }
}

class CommunitySpecificFields extends StatelessWidget {
  const CommunitySpecificFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
              controller: provider.addressController1,
              labelText: 'Locate your item',
              hintText: 'Enter item location',
            ),
            AppSpacing.verticalMD,

            // Building or Street Name
            CustomFormField(
              controller: provider.addressController2,
              labelText: 'Building or Street Name',
              hintText: 'Enter building/street name',
            ),
          ],
        );
      },
    );
  }
}
