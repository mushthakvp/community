class SearchResult {
  final bool success;
  final String message;
  final List<SearchAd> ads;
  final int totalAds;
  final String currencyCode;

  const SearchResult({
    required this.success,
    required this.message,
    required this.ads,
    required this.totalAds,
    required this.currencyCode,
  });
}

class SearchAd {
  final String id;
  final String title;
  final double price;
  final String? brand;
  final List<String> images;
  final String? shareLink;

  const SearchAd({
    required this.id,
    required this.title,
    required this.price,
    this.brand,
    required this.images,
    this.shareLink,
  });
}
