import 'package:equatable/equatable.dart';

class OrderDetails extends Equatable {
  final bool success;
  final OrderDetailsData? order;
  final bool? isReturned;
  final OrderShippingAddress? shippingAddress;

  const OrderDetails({
    required this.success,
    this.order,
    this.isReturned,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [success, order, isReturned, shippingAddress];
}

class OrderDetailsData extends Equatable {
  final String? id;
  final String? orderId;
  final String? productName;
  final num? quantity;
  final List<String>? images;
  final num? price;
  final num? offerPrice;
  final num? commission;
  final num? discount;
  final num? tax;
  final num? couponDiscount;
  final num? total;
  final String? orderStatus;

  const OrderDetailsData({
    this.id,
    this.orderId,
    this.productName,
    this.quantity,
    this.images,
    this.price,
    this.offerPrice,
    this.commission,
    this.discount,
    this.tax,
    this.couponDiscount,
    this.total,
    this.orderStatus,
  });

  double get finalPrice => ((offerPrice ?? 0) + (commission ?? 0)).toDouble();
  double get subtotal => (total ?? 0).toDouble();
  double get taxAmount => (tax ?? 0).toDouble();
  double get discountAmount => (discount ?? 0).toDouble();
  double get couponDiscountAmount => (couponDiscount ?? 0).toDouble();
  double get grandTotal =>
      subtotal + taxAmount + discountAmount + couponDiscountAmount;

  @override
  List<Object?> get props => [
    id,
    orderId,
    productName,
    quantity,
    images,
    price,
    offerPrice,
    commission,
    discount,
    tax,
    couponDiscount,
    total,
    orderStatus,
  ];
}

class OrderShippingAddress extends Equatable {
  final String? id;
  final ShippingAddressDetails? shippingAddress;

  const OrderShippingAddress({this.id, this.shippingAddress});

  @override
  List<Object?> get props => [id, shippingAddress];
}

class ShippingAddressDetails extends Equatable {
  final String? id;
  final String? userId;
  final String? title;
  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? pinCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShippingAddressDetails({
    this.id,
    this.userId,
    this.title,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.pinCode,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedAddress {
    final parts = <String>[];
    if (address?.isNotEmpty == true) parts.add(address!);
    if (city?.isNotEmpty == true) parts.add(city!);
    if (state?.isNotEmpty == true) parts.add(state!);
    if (pinCode?.isNotEmpty == true) parts.add(pinCode!);
    return parts.join(', ');
  }

  String get displayTitle => title?.toUpperCase() ?? 'ADDRESS';

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    name,
    phone,
    address,
    city,
    state,
    pinCode,
    createdAt,
    updatedAt,
  ];
}
