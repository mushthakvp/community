import '../../domain/entities/order_history.dart';

class OrderHistoryModel extends OrderHistory {
  const OrderHistoryModel({
    required super.success,
    required super.orders,
    required super.availableYears,
    super.pagination,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      success: json['success'] ?? false,
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((x) => OrderGroupModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      availableYears: (json['availableYears'] as List<dynamic>? ?? [])
          .map((x) => x as int)
          .toList(),
      pagination: json['pagination'] != null
          ? OrderPaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'orders': orders.map((x) => (x as OrderGroupModel).toJson()).toList(),
      'availableYears': availableYears,
      'pagination': (pagination as OrderPaginationModel?)?.toJson(),
    };
  }
}

class OrderGroupModel extends OrderGroup {
  const OrderGroupModel({super.orderDate, required super.items});

  factory OrderGroupModel.fromJson(Map<String, dynamic> json) {
    return OrderGroupModel(
      orderDate: json['orderDate'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((x) => OrderItemModel.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderDate': orderDate,
      'items': items.map((x) => (x as OrderItemModel).toJson()).toList(),
    };
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({super.orderId, super.product});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderId: json['orderId'] as String?,
      product: json['product'] != null
          ? OrderProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'product': (product as OrderProductModel?)?.toJson(),
    };
  }
}

class OrderProductModel extends OrderProduct {
  const OrderProductModel({
    super.name,
    super.image,
    super.price,
    super.offerPrice,
    super.commission,
    super.status,
    super.isReturned,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      offerPrice: (json['offerPrice'] as num?)?.toDouble(),
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String?,
      isReturned: json['isReturned'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'offerPrice': offerPrice,
      'commission': commission,
      'status': status,
      'isReturned': isReturned,
    };
  }
}

class OrderPaginationModel extends OrderPagination {
  const OrderPaginationModel({
    super.currentPage,
    super.totalPages,
    super.totalOrders,
    super.hasMore,
  });

  factory OrderPaginationModel.fromJson(Map<String, dynamic> json) {
    return OrderPaginationModel(
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
      totalOrders: json['totalOrders'] as int?,
      hasMore: json['hasMore'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalOrders': totalOrders,
      'hasMore': hasMore,
    };
  }
}
