import 'package:equatable/equatable.dart';

class OrderHistory extends Equatable {
  final bool success;
  final List<OrderGroup> orders;
  final List<int> availableYears;
  final OrderPagination? pagination;

  const OrderHistory({
    required this.success,
    required this.orders,
    required this.availableYears,
    this.pagination,
  });

  @override
  List<Object?> get props => [success, orders, availableYears, pagination];
}

class OrderGroup extends Equatable {
  final String? orderDate;
  final List<OrderItem> items;

  const OrderGroup({this.orderDate, required this.items});

  @override
  List<Object?> get props => [orderDate, items];
}

class OrderItem extends Equatable {
  final String? orderId;
  final OrderProduct? product;

  const OrderItem({this.orderId, this.product});

  @override
  List<Object?> get props => [orderId, product];
}

class OrderProduct extends Equatable {
  final String? name;
  final String? image;
  final double? price;
  final double? offerPrice;
  final double? commission;
  final String? status;
  final bool? isReturned;

  const OrderProduct({
    this.name,
    this.image,
    this.price,
    this.offerPrice,
    this.commission,
    this.status,
    this.isReturned,
  });

  double get finalPrice => (offerPrice ?? 0) + (commission ?? 0);

  @override
  List<Object?> get props => [
    name,
    image,
    price,
    offerPrice,
    commission,
    status,
    isReturned,
  ];
}

class OrderPagination extends Equatable {
  final int? currentPage;
  final int? totalPages;
  final int? totalOrders;
  final bool? hasMore;

  const OrderPagination({
    this.currentPage,
    this.totalPages,
    this.totalOrders,
    this.hasMore,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, totalOrders, hasMore];
}
