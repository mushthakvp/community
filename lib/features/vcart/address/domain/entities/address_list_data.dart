import 'package:equatable/equatable.dart';

import 'address.dart';

class AddressListData extends Equatable {
  final List<Address> addresses;
  final bool isLoading;
  final bool hasMoreData;
  final int currentPage;
  final String? errorMessage;

  const AddressListData({
    required this.addresses,
    this.isLoading = false,
    this.hasMoreData = true,
    this.currentPage = 1,
    this.errorMessage,
  });

  bool get isEmpty => addresses.isEmpty;
  bool get isNotEmpty => addresses.isNotEmpty;
  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
    addresses,
    isLoading,
    hasMoreData,
    currentPage,
    errorMessage,
  ];

  AddressListData copyWith({
    List<Address>? addresses,
    bool? isLoading,
    bool? hasMoreData,
    int? currentPage,
    String? errorMessage,
  }) {
    return AddressListData(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }
}
