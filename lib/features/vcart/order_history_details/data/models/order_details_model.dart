import '../../domain/entities/order_details.dart';

class OrderDetailsModel extends OrderDetails {
  const OrderDetailsModel({
    required super.success,
    super.order,
    super.isReturned,
    super.shippingAddress,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json['success'] ?? false,
      order: json['order'] != null
          ? OrderDetailsDataModel.fromJson(
              json['order'] as Map<String, dynamic>,
            )
          : null,
      isReturned: json['isReturned'] as bool?,
      shippingAddress: json['shippingAddress'] != null
          ? OrderShippingAddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'order': (order as OrderDetailsDataModel?)?.toJson(),
      'isReturned': isReturned,
      'shippingAddress': (shippingAddress as OrderShippingAddressModel?)
          ?.toJson(),
    };
  }
}

class OrderDetailsDataModel extends OrderDetailsData {
  const OrderDetailsDataModel({
    super.id,
    super.orderId,
    super.productName,
    super.quantity,
    super.images,
    super.price,
    super.offerPrice,
    super.commission,
    super.discount,
    super.tax,
    super.couponDiscount,
    super.total,
    super.orderStatus,
  });

  factory OrderDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsDataModel(
      id: json['_id'] as String?,
      orderId: json['orderId'] as String?,
      productName: json['productName'] as String?,
      quantity: json['quantity'] as num?,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      price: json['price'] as num?,
      offerPrice: json['offerPrice'] as num?,
      commission: json['commission'] as num?,
      discount: json['discount'] as num?,
      tax: json['tax'] as num?,
      couponDiscount: json['couponDiscount'] as num?,
      total: json['total'] as num?,
      orderStatus: json['orderStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'productName': productName,
      'quantity': quantity,
      'images': images,
      'price': price,
      'offerPrice': offerPrice,
      'commission': commission,
      'discount': discount,
      'tax': tax,
      'couponDiscount': couponDiscount,
      'total': total,
      'orderStatus': orderStatus,
    };
  }
}

class OrderShippingAddressModel extends OrderShippingAddress {
  const OrderShippingAddressModel({super.id, super.shippingAddress});

  factory OrderShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderShippingAddressModel(
      id: json['_id'] as String?,
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddressDetailsModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'shippingAddress': (shippingAddress as ShippingAddressDetailsModel?)
          ?.toJson(),
    };
  }
}

class ShippingAddressDetailsModel extends ShippingAddressDetails {
  const ShippingAddressDetailsModel({
    super.id,
    super.userId,
    super.title,
    super.name,
    super.phone,
    super.address,
    super.city,
    super.state,
    super.pinCode,
    super.createdAt,
    super.updatedAt,
  });

  factory ShippingAddressDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressDetailsModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pinCode: json['pinCode'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
