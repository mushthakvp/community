import 'package:equatable/equatable.dart';

import 'ad_entity.dart';

class AdsResponseEntity extends Equatable {
  final List<AdEntity> ads;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const AdsResponseEntity({
    required this.ads,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
    ads,
    totalCount,
    currentPage,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  ];
}
