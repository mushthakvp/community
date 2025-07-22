enum OrderStatus {
  orderPlaced('Order Placed'),
  delivered('Delivered'),
  cancelled('Cancelled'),
  shipped('Shipped'),
  packed('Packed'),
  returned('Returned'),
  outForDelivery('Out for Delivery');

  const OrderStatus(this.displayName);
  final String displayName;

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'order placed':
        return OrderStatus.orderPlaced;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'shipped':
        return OrderStatus.shipped;
      case 'packed':
        return OrderStatus.packed;
      case 'returned':
        return OrderStatus.returned;
      case 'out for delivery':
        return OrderStatus.outForDelivery;
      default:
        return OrderStatus.orderPlaced;
    }
  }
}
