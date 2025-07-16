import 'package:flutter/material.dart';

import '../../../../../core/utils/result.dart';
import '../../domain/entities/seller_profile.dart';
import '../../domain/usecases/get_seller_profile_usecase.dart';

class SellerDetailsProvider extends ChangeNotifier {
  final GetSellerProfileUseCase getSellerProfileUseCase;

  SellerDetailsProvider({required this.getSellerProfileUseCase});

  Result<SellerProfile>? _sellerProfileResult;
  bool _isLoading = false;

  Result<SellerProfile>? get sellerProfileResult => _sellerProfileResult;
  bool get isLoading => _isLoading;
  SellerProfile? get sellerProfile => _sellerProfileResult?.data;

  Future<void> getSellerProfile(String sellerId) async {
    _isLoading = true;
    notifyListeners();

    final result = await getSellerProfileUseCase(sellerId);

    result.fold(
      (failure) => _sellerProfileResult = Error(message: failure.message),
      (profile) => _sellerProfileResult = Success(profile),
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _sellerProfileResult = null;
    _isLoading = false;
    notifyListeners();
  }
}
