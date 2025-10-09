import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/ad_creation.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/city.dart';
import '../../domain/usecases/create_ad_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/upload_images_usecase.dart';

class PlaceAddProvider extends ChangeNotifier {
  final GetCitiesUseCase getCitiesUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateAdUseCase createAdUseCase;
  final UploadImagesUseCase uploadImagesUseCase;

  PlaceAddProvider({
    required this.getCitiesUseCase,
    required this.getCategoriesUseCase,
    required this.createAdUseCase,
    required this.uploadImagesUseCase,
  });

  // State management
  Result<List<City>>? _citiesResult;
  Result<List<Category>>? _categoriesResult;
  Result<AdCreationResponse>? _adCreationResult;

  bool _isLoading = false;
  final bool _isCreatingAd = false;
  final bool _isUploadingImages = false;

  // All Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final kilometerController = TextEditingController();
  final transmissionController = TextEditingController();
  final colorController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final usageController = TextEditingController();
  final conditionController = TextEditingController();
  final sellerTypeController = TextEditingController();
  final categoryController = TextEditingController();
  final ageController = TextEditingController();
  final engineCapacityController = TextEditingController();
  final warrantyController = TextEditingController();
  final brandController = TextEditingController();
  final memoryController = TextEditingController();
  final processorController = TextEditingController();
  final hardDriveController = TextEditingController();
  final typeController = TextEditingController();
  final durationController = TextEditingController();
  final ratingController = TextEditingController();
  final damageController = TextEditingController();
  final damageDetailsController = TextEditingController();
  final materialsController = TextEditingController();
  final batteryPercentageController = TextEditingController();
  final versionController = TextEditingController();
  final accompanimentsController = TextEditingController();
  final imeiNumberController = TextEditingController();
  final storageCapacityController = TextEditingController();
  final memoryRamController = TextEditingController();
  final numberOfTicketsController = TextEditingController();
  final farmFreshCategoryController = TextEditingController();
  final farmFreshQuantityController = TextEditingController();
  final addressController1 = TextEditingController();
  final addressController2 = TextEditingController();
  final rentIsPaidController = TextEditingController();
  final rentPropertyReferenceIdController = TextEditingController();
  final rentMinimumContractPeriodController = TextEditingController();
  final noticePeriodController = TextEditingController();
  final rentBuildingController = TextEditingController();
  final youtubeUrlController = TextEditingController();
  final landSizeController = TextEditingController();
  final landPriceController = TextEditingController();
  final landReferenceIdController = TextEditingController();
  final landBuyerTransferFee = TextEditingController();
  final landSellerTransferFee = TextEditingController();
  final landListedByController = TextEditingController();
  final landZoneController = TextEditingController();
  final landApproveBuildArea = TextEditingController();
  final landMaintenanceFeeController = TextEditingController();
  final landOccupancyController = TextEditingController();
  final landBathroomController = TextEditingController();
  final landBedroomController = TextEditingController();
  final landAnnualFeeController = TextEditingController();
  final landFurnishedController = TextEditingController();
  final landPropertyReferenceIdController = TextEditingController();
  final sectionIdStoreController = TextEditingController();
  final selectedCategoryIdController = TextEditingController();
  final carrierLockController = TextEditingController();

  // Selection States
  String? _selectedCity;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  final List<File> _selectedImages = [];
  String? _latitude;
  String? _longitude;
  String? _address;

  // Selection Variables
  String selectedFuelTypeItem = '';
  String selectedColorTypeItem = '';
  String selectedTransmissionTypeItem = '';
  String selectedUsageTypeItem = '';
  String selectedConditionTypeItem = '';
  String selectSellerTypeItem = '';
  String selectedAgeTypeItem = '';
  String selectedProcessorSpeedItem = '';
  String selectedWarrantyItem = '';
  String selectedHardDriveItem = '';
  String selectedMemoryItem = '';
  String selectedBrandItem = '';
  String selectedNumberOfTicketsItem = '';
  String selectedBookTypeItem = '';
  String selectedMusicDurationItem = '';
  String selectedRatingItem = '';
  String selectedBatteryHealthTypeItem = '';
  String selectedCarrierLockItem = '';
  String selectedStorageCapacityTypeItemForMobile = '';
  String landListedBy = "";
  String landZone = "";
  String occupancyStatus = "";
  String furnishedStatus = "";
  String totalBedRoomNumbers = '';
  String totalBathRoomNumbers = '';
  String rentIsPaidStatus = "";
  String selectedFarmFreshTypeCategory = '';
  String farmFreshQuantity = 'Quantity';
  bool carrierLock = false;
  int publishAddStatus = 1;

  // Multiple Selection Lists
  List<String> selectedMaterialsItem = [];
  List<String> selectedDamageDetailsItem = [];
  List<String> selectedAccompanimentsItem = [];
  List<String> selectedItems = []; // For rent extras

  // All Hardcoded Lists
  List<String> fuelTypeList = ["Petrol", "Diesel", "Electric", "Hybrid"];

  List<String> colorTypeList = [
    "Black",
    "White",
    "Red",
    "Blue",
    "Green",
    "Grey",
    "Silver",
    "Brown",
    "Yellow",
    "Orange",
    "Purple",
    "Pink",
    "Beige",
    "Gold",
    "Maroon",
    "Turquoise",
    "Teal",
    "Navy",
    "Lime",
    "Other",
  ];

  List<String> transmissionTypeList = [
    "Manual Transmission",
    "Automatic Transmission",
  ];

  List<String> usageTypeList = [
    "Never Used",
    "Used Once",
    "Light Usage",
    "Normal Usage",
    "Heavy Usage",
  ];

  List<String> conditionTypeList = [
    "Perfect inside and out",
    "Almost no noticeable problems or flaws",
    "A bit of wear and tear, but in good working condition",
    "Normal wear and tear for the age of the item, a few problems here and there",
    "Above average wear and tear. The item may need a bit of repair to work properly",
  ];

  List<String> sellerTypeList = ["Owner", "Dealer"];

  List<String> ageTypeList = [
    "Brand New",
    "0-1 months",
    "1-6 months",
    "6-12 months",
    "1-2 years",
    "2-5 years",
    "5-10 years",
    "10+ years",
  ];

  List<String> processorSpeedList = [
    "Less Than 500 MHz",
    "500 MHz or More",
    "1 GHz or more",
    "2 GHz or more",
  ];

  List<String> warrantyList = ["Yes", "No", "Does Not Apply"];

  List<String> hardDriveList = [
    "0 - 99 GB",
    "100 - 249 GB",
    "250 GB or More",
    "250 - 499 GB",
    "500 - 749 GB",
    "750 - 999 GB",
    "1 - 1.49 TB",
    "1.5 - 1.9 TB",
    "2+ TB",
  ];

  List<String> memoryList = [
    "1 GB or less",
    "2 GB",
    "3 GB",
    "4 GB",
    "6 GB",
    "8 GB",
    "12 GB",
    "16 GB",
    "32 GB or more",
  ];

  List<String> brandList = [
    "Acer",
    "Apple",
    "Asus",
    "Dell",
    "HP",
    "Lenovo",
    "MSI",
    "Razer",
    "Samsung",
    "Sony",
    "Toshiba",
    "LG",
    "Panasonic",
    "Philips",
    "Bosch",
    "Whirlpool",
    "GE Appliances",
    "Siemens",
    "Hitachi",
    "Electrolux",
    "Frigidaire",
    "Nike",
    "Adidas",
    "Puma",
    "Under Armour",
    "Reebok",
    "Asics",
    "New Balance",
    "Wilson",
    "Yonex",
    "Head",
    "Babolat",
    "Mizuno",
    "Spalding",
    "Slazenger",
    "Canon",
    "Nikon",
    "Olympus",
    "Fujifilm",
    "Leica",
    "Pentax",
    "GoPro",
    "Kodak",
    "Sigma",
    "Hasselblad",
    "Zara",
    "H&M",
    "Uniq",
    "Levi's",
    "Gap",
    "Ralph Lauren",
    "Tommy Hilfiger",
    "Gucci",
    "Prada",
    "Tiffany & Co.",
    "Cartier",
    "Rolex",
    "Omega",
    "Pate Philippe",
    "Tag Hewer",
    "Bvlgari",
    "Chopard",
    "Harry Winston",
    "Van Cleef & Arpels",
    "Seiko",
    "Fossil",
    "Other",
  ];

  List<String> materialsList = [
    "Amber",
    "Beads",
    "Bronze",
    "Ceramic",
    "Gold",
    "Iron",
    "Lead",
    "Crystal",
    "Platinum",
    "Silver",
    "Steel",
    "Titanium",
    "Zinc",
    "Wood",
    "Leather",
    "Plastic",
    "Rubber",
    "Diamond",
    "Rhinestones",
    "Gemstone",
    "Other",
  ];

  List<String> numberOfTicketsList = [
    "Single Ticket",
    "Pair of Tickets",
    "3 Tickets",
    "4 Tickets",
    "4+ Tickets",
  ];

  List<String> bookTypeList = ["HandCover", "Paperback"];

  List<String> musicDurationList = [
    "Album or EP",
    "Box Set",
    "Single",
    "Other",
  ];

  List<String> ratingList = [
    "G",
    "PG",
    "PG-13",
    "R",
    "NC-17",
    "Unrated",
    "Other",
  ];

  List<String> damageDetailsList = [
    "No Damage",
    "Minor Scratches",
    "Major Scratches",
    "Cracked or Broken Screen",
    "Audio Not working",
    "Not Charging",
    "Not Turning On",
    "Network/connectivity issue",
    "Camera Damage",
    "Other",
  ];

  List<String> batteryHealthTypeList = ["Below 85%", "Above 85%"];

  List<String> accompanimentsList = [
    "Charger",
    "Headphones",
    "Box",
    "Manual",
    "Wireless Charger",
    "Other",
  ];

  List<String> selectedCarrierLockItemList = ["Yes", "No"];

  List<String> storageCapacityTypeItemForMobileList = [
    "32 GB",
    "64 GB",
    "128 GB",
    "256 GB",
    "512 GB",
    "1 TB",
  ];

  // Property Related Lists
  List<String> landListedByList = ["Agent", "LandLord", "Developer"];
  List<String> bedroomNumbers = ["1", "2", "3", '4', '5', '6', 'more'];
  List<String> bathroomNumbers = ["1", "2", "3", '4', '5', '6', 'more'];
  List<String> isItFurnished = ['Yes', 'No'];

  List<String> landZoneList = [
    "Residential",
    "Commercial",
    "Retail",
    "Industrial",
    "Mixed Use",
  ];

  List<String> occupancyStatusList = ["Vacant", "Occupied"];

  List<String> furnishedStatusList = [
    "Furnished",
    "Unfurnished",
    "Partially Furnished",
    "Not Specified",
  ];

  // Farm Fresh Lists
  List<String> farmFreshCategory = ['Fruits', 'Vegetables'];
  List<String> farmFreshQuantityList = [
    '0.5kg',
    '1kg',
    '1.5kg',
    '2kg',
    '2.5kg',
    '3kg',
    '3.5kg',
    '4kg',
    '5kg',
    '6kg',
    '7kg',
    '8kg',
    '9kg',
    '10kg',
  ];

  // Rent Extras List
  List<String> rentExtras = [
    'Maids Room',
    'Study',
    'Central A/c & Heating',
    'Concierge Services',
    'Balcony',
    'Private Garden',
    'Covered Parking',
    'Private Pool',
    'Private Gym',
    'Private Jacuzzi',
    'Shared Pool',
    'Shared Spa',
    'Shared Gym',
    'Security',
    'Maid Services',
    'Built in Wardrobes',
    'Walk-in closet',
    'Built in Kitchen Appliances',
    'View of Water',
    'View of Landmark',
    'Pets Allowed',
    'Double Glazed Windows',
    'Day Care Center',
    'Electricity Backup',
    'First Aid Medical Center',
    'Service Elevators',
    'Prayers Room',
    'Laundry Room',
    'Broadband Internet',
    'Satellite / Cable TV',
    'Business Center',
    'Intercom',
    'Shared Kitchen',
    'Facilities for Disabled',
    'Storage Area',
    'Barbecue Area',
    'Lobby in Building',
    'Waste Disposal',
  ];

  // Getters
  Result<List<City>>? get citiesResult => _citiesResult;
  Result<List<Category>>? get categoriesResult => _categoriesResult;
  Result<AdCreationResponse>? get adCreationResult => _adCreationResult;

  bool get isLoading => _isLoading;
  bool get isCreatingAd => _isCreatingAd;
  bool get isUploadingImages => _isUploadingImages;

  List<City>? get cities => _citiesResult?.data;
  List<Category>? get categories => _categoriesResult?.data;

  String? get selectedCity => _selectedCity;
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;
  List<File> get selectedImages => _selectedImages;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get address => _address;

  // Actions
  Future<void> loadCities() async {
    debugPrint('Loading cities...');
    _isLoading = true;
    notifyListeners();
    final result = await getCitiesUseCase(NoParams());
    result.fold((failure) {
      debugPrint(
        "Error loading cities: ${result.fold((l) => l.message, (r) => '')}",
      );
      return _citiesResult = Error(message: failure.message);
    }, (cities) => _citiesResult = Success(cities));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => _categoriesResult = Error(message: failure.message),
      (categories) => _categoriesResult = Success(categories),
    );

    _isLoading = false;
    notifyListeners();
  }

  void selectCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void selectCategory(Category category) {
    _selectedCategory = category;
    _selectedSubCategory = null;
    notifyListeners();
  }

  void selectSubCategory(SubCategory subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  // Image Management
  Future<void> addImage(bool isGallery) async {
    if (_selectedImages.length < 10) {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (image != null) {
        _selectedImages.add(File(image.path));
        notifyListeners();
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  // Location Management
  void setLocation(double latitude, double longitude, String address) {
    _latitude = latitude.toString();
    _longitude = longitude.toString();
    _address = address;
    notifyListeners();
  }

  Future<String> getPlaceNameFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _latitude = latitude.toString();
        _longitude = longitude.toString();
        _address = place.locality ?? "Place name not found";
        notifyListeners();
        return place.locality ?? "Place name not found";
      }
    } catch (e) {
      notifyListeners();
    }
    return "Place name not found";
  }

  // Selection Methods
  void selectFueltypeFn(String fuelType) {
    selectedFuelTypeItem = fuelType;
    fuelTypeController.text = fuelType;
    notifyListeners();
  }

  void selectColorTypeFn(String colorType) {
    selectedColorTypeItem = colorType;
    colorController.text = colorType;
    notifyListeners();
  }

  void selectTransmissionTypeFn(String transmission) {
    selectedTransmissionTypeItem = transmission;
    transmissionController.text = transmission;
    notifyListeners();
  }

  void selectUsageTypeFn(String usage) {
    selectedUsageTypeItem = usage;
    usageController.text = usage;
    notifyListeners();
  }

  void selectConditionTypeFn(String condition) {
    selectedConditionTypeItem = condition;
    conditionController.text = condition;
    notifyListeners();
  }

  void selectSellerTypeFn(String seller) {
    selectSellerTypeItem = seller;
    sellerTypeController.text = seller;
    notifyListeners();
  }

  void selectAgeTypeFn(String age) {
    selectedAgeTypeItem = age;
    ageController.text = age;
    notifyListeners();
  }

  void selectProcessorSpeedFn(String processorSpeed) {
    selectedProcessorSpeedItem = processorSpeed;
    processorController.text = processorSpeed;
    notifyListeners();
  }

  void selectWarrantyFn(String warranty) {
    selectedWarrantyItem = warranty;
    warrantyController.text = warranty;
    notifyListeners();
  }

  void selectHardDriveFn(String hardDrive) {
    selectedHardDriveItem = hardDrive;
    hardDriveController.text = hardDrive;
    notifyListeners();
  }

  void selectMemoryFn(String memory) {
    selectedMemoryItem = memory;
    memoryRamController.text = memory;
    notifyListeners();
  }

  void selectBrandFn(String brand) {
    selectedBrandItem = brand;
    brandController.text = brand;
    notifyListeners();
  }

  void selectMaterialsFn(String materials) {
    if (selectedMaterialsItem.contains(materials)) {
      selectedMaterialsItem.remove(materials);
    } else {
      selectedMaterialsItem.add(materials);
    }
    materialsController.text = selectedMaterialsItem.join(", ");
    notifyListeners();
  }

  void selectNumberOfTicketsFn(String numberOfTickets) {
    selectedNumberOfTicketsItem = numberOfTickets;
    numberOfTicketsController.text = numberOfTickets;
    notifyListeners();
  }

  void selectBookTypeFn(String bookType) {
    selectedBookTypeItem = bookType;
    typeController.text = bookType;
    notifyListeners();
  }

  void selectMusicDurationFn(String musicDuration) {
    selectedMusicDurationItem = musicDuration;
    durationController.text = musicDuration;
    notifyListeners();
  }

  void selectRatingFn(String rating) {
    selectedRatingItem = rating;
    ratingController.text = rating;
    notifyListeners();
  }

  void selectDamageDetailsFn(String damageDetails) {
    if (selectedDamageDetailsItem.contains(damageDetails)) {
      selectedDamageDetailsItem.remove(damageDetails);
    } else {
      selectedDamageDetailsItem.add(damageDetails);
    }
    damageDetailsController.text = selectedDamageDetailsItem.join(", ");
    notifyListeners();
  }

  void selectBatteryHealthTypeFn(String batteryHealthType) {
    selectedBatteryHealthTypeItem = batteryHealthType;
    batteryPercentageController.text = batteryHealthType;
    notifyListeners();
  }

  void selectAccompanimentsFn(String accompaniment) {
    if (selectedAccompanimentsItem.contains(accompaniment)) {
      selectedAccompanimentsItem.remove(accompaniment);
    } else {
      selectedAccompanimentsItem.add(accompaniment);
    }
    accompanimentsController.text = selectedAccompanimentsItem.join(", ");
    notifyListeners();
  }

  void selectCarrierLockFn(String carrierLockValue) {
    selectedCarrierLockItem = carrierLockValue;
    carrierLockController.text = selectedCarrierLockItem;
    carrierLock = carrierLockValue == "Yes";
    notifyListeners();
  }

  void selectStorageCapacityTypeItemForMobileTypeFn(
    String storageCapacityType,
  ) {
    selectedStorageCapacityTypeItemForMobile = storageCapacityType;
    storageCapacityController.text = storageCapacityType;
    notifyListeners();
  }

  // Property Related Methods
  void addLandListedBy({required String value}) {
    landListedBy = value;
    landListedByController.text = value;
    notifyListeners();
  }

  void addLandZone({required String value}) {
    landZone = value;
    landZoneController.text = value;
    notifyListeners();
  }

  void addOccupancyStatus({required String value}) {
    occupancyStatus = value;
    landOccupancyController.text = value;
    notifyListeners();
  }

  void addFurnishedStatus({required String value}) {
    furnishedStatus = value;
    landFurnishedController.text = value;
    notifyListeners();
  }

  void bedRoomNumbers({required String value}) {
    totalBedRoomNumbers = value;
    landBedroomController.text = value;
    notifyListeners();
  }

  void bathroomNumbersFn({required String value}) {
    totalBathRoomNumbers = value;
    landBathroomController.text = value;
    notifyListeners();
  }

  void addRentIsPaidStatus({required String value}) {
    rentIsPaidStatus = value;
    rentIsPaidController.text = value;
    notifyListeners();
  }

  // Farm Fresh Methods
  void setSelectedFarmFreshTypeCategory(String value) {
    selectedFarmFreshTypeCategory = value;
    farmFreshCategoryController.text = value;
    notifyListeners();
  }

  void setFarmFreshQuantity(String value) {
    farmFreshQuantity = value;
    farmFreshQuantityController.text = value;
    notifyListeners();
  }

  // Rent Extras Management
  void toggleSelection(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    notifyListeners();
  }

  bool isSelected(String item) {
    return selectedItems.contains(item);
  }

  // Search Functionality
  List<String> cityList = [];

  void searchDistricts(String query) {
    final cities = _citiesResult?.data;
    if (cities != null) {
      if (query.isNotEmpty && query.length > 2) {
        cityList = cities
            .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()),
            )
            .map((city) => city.name)
            .toList();
      } else {
        cityList = cities.map((city) => city.name).toList();
      }
      notifyListeners();
    }
  }

  // Create Ad with all parameters
  Future<void> createAd({
    String subSubcategoryId = '',
    String subItemsId = '',
    String isFromAgentOrLandlord = '',
  }) async {
    if (!_validateForm()) return;

    publishAddStatus = 0;
    notifyListeners();

    try {
      // Upload images first
      final imageFiles = _selectedImages
          .map((file) => XFile(file.path))
          .toList();
      final imageUploadResult = await uploadImagesUseCase(imageFiles);

      List<String> imageUrls = [];
      imageUploadResult.fold((failure) {
        _adCreationResult = Error(message: failure.message);
        publishAddStatus = 1;
        notifyListeners();
        return;
      }, (urls) => imageUrls = urls);

      // Parse numeric values
      final year = int.tryParse(yearController.text.trim());
      final kilometers = num.tryParse(kilometerController.text.trim());
      final price = num.tryParse(priceController.text.trim()) ?? 0;
      final engineCapacity = num.tryParse(engineCapacityController.text.trim());

      // Build comprehensive parameters map
      final additionalFields = <String, dynamic>{
        "district": _selectedCity?.trim().isEmpty == true
            ? 'Kannur'
            : _selectedCity?.trim(),
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "images": imageUrls,
        "category": sectionIdStoreController.text.trim(),
        "subCategory": selectedCategoryIdController.text.trim(),
        'subSubcategory': subSubcategoryId.trim(),
        "subItem": subItemsId.trim(),
        "latitude": _latitude?.trim(),
        "longitude": _longitude?.trim(),
        "address": addressController1.text.trim().isNotEmpty
            ? '${addressController1.text.trim()} && ${addressController2.text.trim()}'
            : _address?.trim(),
        "price": price,
        "phone": phoneController.text.trim(),

        // Motor/Vehicle fields
        "fuelType": fuelTypeController.text.trim(),
        "color": colorController.text.trim(),
        "transmissionType": transmissionController.text.trim(),
        "usage": usageController.text.trim(),
        "condition": conditionController.text.trim(),
        "sellerType": sellerTypeController.text.trim(),
        "model": modelController.text.trim(),

        // Electronics fields
        "warranty": warrantyController.text.trim(),
        "brand": brandController.text.trim(),
        "memory": memoryController.text.trim(),
        "processor": processorController.text.trim(),
        "hardDrive": hardDriveController.text.trim(),
        "memoryRam": memoryRamController.text.trim(),

        // General item fields
        "type": typeController.text.trim(),
        "duration": durationController.text.trim(),
        "rating": ratingController.text.trim(),
        "damage": damageController.text.trim(),
        "damageDetails": damageDetailsController.text.trim(),
        "materials": materialsController.text.trim(),
        "batteryPercentage": batteryPercentageController.text.trim(),
        "version": versionController.text.trim(),
        "accompaniments": accompanimentsController.text.trim(),
        "carrierLock": carrierLock,
        "imeiNumber": imeiNumberController.text.trim(),
        "storageCapacity": storageCapacityController.text.trim(),
        "numberOfTickets": numberOfTicketsController.text.trim(),

        // Farm fresh fields
        'quantity': farmFreshQuantityController.text.trim(),

        // Property fields
        "size": landSizeController.text.trim(),
        "closingFee": landPriceController.text.trim(),
        "referenceId": landReferenceIdController.text.trim(),
        "buyerFee": landBuyerTransferFee.text.trim(),
        "sellerFee": landSellerTransferFee.text.trim(),
        "listedBy": landListedByController.text.trim(),
        "zonedFor": landZoneController.text.trim(),
        "areaSize": landApproveBuildArea.text.trim(),
        "bedrooms": landBedroomController.text.trim(),
        "bathrooms": landBathroomController.text.trim(),
        "annualCommunityFee": landAnnualFeeController.text.trim(),
        "isFurnished": landFurnishedController.text.trim(),
        "maintenanceFee": landMaintenanceFeeController.text.trim(),
        "landlordAgent": isFromAgentOrLandlord,
        "rentPaid": rentIsPaidController.text.trim(),
        "contractPeriod": rentMinimumContractPeriodController.text.trim(),
        "noticePeriod": noticePeriodController.text.trim(),
        "youtubeUrl": youtubeUrlController.text.trim(),
      };

      // Add numeric fields if available
      if (year != null) additionalFields['year'] = year;
      if (kilometers != null) additionalFields['kilometers'] = kilometers;
      if (engineCapacity != null) {
        additionalFields['engineCapacity'] = engineCapacity;
      }
      if (selectedItems.isNotEmpty) additionalFields['extras'] = selectedItems;

      // Create ad request
      final request = AdCreationRequest(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: price.toDouble(),
        phoneNumber: phoneController.text.trim(),
        district: _selectedCity ?? 'Kannur',
        categoryId: sectionIdStoreController.text.trim(),
        subCategoryId: selectedCategoryIdController.text.trim(),
        subSubCategoryId: subSubcategoryId.isNotEmpty ? subSubcategoryId : null,
        images: imageUrls,
        latitude: double.tryParse(_latitude ?? '0') ?? 0,
        longitude: double.tryParse(_longitude ?? '0') ?? 0,
        address: _address ?? '',
        additionalFields: additionalFields,
      );

      // Create ad
      final result = await createAdUseCase(request);
      result.fold(
        (failure) {
          _adCreationResult = Error(message: failure.message);
          publishAddStatus = 1;
        },
        (response) {
          _adCreationResult = Success(response);
          clearAllData();
          publishAddStatus = 1;
        },
      );
    } catch (e) {
      _adCreationResult = Error(message: 'Unexpected error occurred: $e');
      publishAddStatus = 1;
    }

    notifyListeners();
  }

  bool _validateForm() {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        _selectedCity != null &&
        _selectedImages.isNotEmpty &&
        _latitude != null &&
        _longitude != null &&
        _address != null;
  }

  // Clear all data
  void clearAllData() {
    // Clear all image lists
    _selectedImages.clear();

    // Clear all text controllers
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    modelController.clear();
    phoneController.clear();
    yearController.clear();
    kilometerController.clear();
    transmissionController.clear();
    colorController.clear();
    fuelTypeController.clear();
    usageController.clear();
    conditionController.clear();
    sellerTypeController.clear();
    categoryController.clear();
    ageController.clear();
    engineCapacityController.clear();
    warrantyController.clear();
    brandController.clear();
    memoryController.clear();
    processorController.clear();
    hardDriveController.clear();
    typeController.clear();
    durationController.clear();
    ratingController.clear();
    damageController.clear();
    damageDetailsController.clear();
    materialsController.clear();
    batteryPercentageController.clear();
    versionController.clear();
    accompanimentsController.clear();
    imeiNumberController.clear();
    storageCapacityController.clear();
    memoryRamController.clear();
    numberOfTicketsController.clear();
    farmFreshCategoryController.clear();
    farmFreshQuantityController.clear();
    addressController1.clear();
    addressController2.clear();
    rentIsPaidController.clear();
    rentPropertyReferenceIdController.clear();
    rentMinimumContractPeriodController.clear();
    noticePeriodController.clear();
    rentBuildingController.clear();
    youtubeUrlController.clear();
    carrierLockController.clear();

    // Clear property controllers
    propertyClear();

    // Reset selection variables
    selectedFuelTypeItem = '';
    selectedColorTypeItem = '';
    selectedTransmissionTypeItem = '';
    selectedUsageTypeItem = '';
    selectedConditionTypeItem = '';
    selectSellerTypeItem = '';
    selectedAgeTypeItem = '';
    selectedProcessorSpeedItem = '';
    selectedWarrantyItem = '';
    selectedHardDriveItem = '';
    selectedMemoryItem = '';
    selectedBrandItem = '';
    selectedMaterialsItem.clear();
    selectedNumberOfTicketsItem = '';
    selectedBookTypeItem = '';
    selectedMusicDurationItem = '';
    selectedRatingItem = '';
    selectedDamageDetailsItem.clear();
    selectedBatteryHealthTypeItem = '';
    selectedAccompanimentsItem.clear();
    selectedCarrierLockItem = '';
    selectedStorageCapacityTypeItemForMobile = '';
    selectedFarmFreshTypeCategory = '';
    farmFreshQuantity = 'Quantity';
    carrierLock = false;

    // Reset location
    _latitude = null;
    _longitude = null;
    _address = null;

    // Reset selections
    _selectedCity = null;
    _selectedCategory = null;
    _selectedSubCategory = null;

    // Reset other variables
    selectedItems.clear();
    publishAddStatus = 1;

    // Reset results
    _adCreationResult = null;

    notifyListeners();
  }

  void propertyClear() {
    landSizeController.clear();
    landPriceController.clear();
    landReferenceIdController.clear();
    landBuyerTransferFee.clear();
    landSellerTransferFee.clear();
    landListedByController.clear();
    landZoneController.clear();
    landApproveBuildArea.clear();
    landMaintenanceFeeController.clear();
    landOccupancyController.clear();
    landBathroomController.clear();
    landBedroomController.clear();
    landAnnualFeeController.clear();
    landFurnishedController.clear();
    landPropertyReferenceIdController.clear();
    sectionIdStoreController.clear();
    selectedCategoryIdController.clear();

    landListedBy = "";
    landZone = "";
    occupancyStatus = "";
    furnishedStatus = "";
    totalBedRoomNumbers = '';
    totalBathRoomNumbers = '';
    rentIsPaidStatus = "";
  }

  @override
  void dispose() {
    // Dispose all controllers
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    phoneController.dispose();
    modelController.dispose();
    yearController.dispose();
    kilometerController.dispose();
    transmissionController.dispose();
    colorController.dispose();
    fuelTypeController.dispose();
    usageController.dispose();
    conditionController.dispose();
    sellerTypeController.dispose();
    categoryController.dispose();
    ageController.dispose();
    engineCapacityController.dispose();
    warrantyController.dispose();
    brandController.dispose();
    memoryController.dispose();
    processorController.dispose();
    hardDriveController.dispose();
    typeController.dispose();
    durationController.dispose();
    ratingController.dispose();
    damageController.dispose();
    damageDetailsController.dispose();
    materialsController.dispose();
    batteryPercentageController.dispose();
    versionController.dispose();
    accompanimentsController.dispose();
    imeiNumberController.dispose();
    storageCapacityController.dispose();
    memoryRamController.dispose();
    numberOfTicketsController.dispose();
    farmFreshCategoryController.dispose();
    farmFreshQuantityController.dispose();
    addressController1.dispose();
    addressController2.dispose();
    rentIsPaidController.dispose();
    rentPropertyReferenceIdController.dispose();
    rentMinimumContractPeriodController.dispose();
    noticePeriodController.dispose();
    rentBuildingController.dispose();
    youtubeUrlController.dispose();
    landSizeController.dispose();
    landPriceController.dispose();
    landReferenceIdController.dispose();
    landBuyerTransferFee.dispose();
    landSellerTransferFee.dispose();
    landListedByController.dispose();
    landZoneController.dispose();
    landApproveBuildArea.dispose();
    landMaintenanceFeeController.dispose();
    landOccupancyController.dispose();
    landBathroomController.dispose();
    landBedroomController.dispose();
    landAnnualFeeController.dispose();
    landFurnishedController.dispose();
    landPropertyReferenceIdController.dispose();
    sectionIdStoreController.dispose();
    selectedCategoryIdController.dispose();
    carrierLockController.dispose();

    super.dispose();
  }
}
