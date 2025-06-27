class WalletRechargeEntity {
  final bool? success;
  final OrderEntity? order;
  final String? currency;
  final PaymentOptionsEntity? options;

  const WalletRechargeEntity({
    this.success,
    this.order,
    this.currency,
    this.options,
  });
}

class OrderEntity {
  final int? amount;
  final int? amountDue;
  final int? amountPaid;
  final int? attempts;
  final int? createdAt;
  final String? currency;
  final String? entity;
  final String? id;
  final List<dynamic>? notes;
  final dynamic offerId;
  final String? receipt;
  final String? status;

  const OrderEntity({
    this.amount,
    this.amountDue,
    this.amountPaid,
    this.attempts,
    this.createdAt,
    this.currency,
    this.entity,
    this.id,
    this.notes,
    this.offerId,
    this.receipt,
    this.status,
  });
}

class PaymentOptionsEntity {
  final String? key;
  final int? amount;
  final String? name;
  final String? description;
  final String? contact;
  final String? email;

  const PaymentOptionsEntity({
    this.key,
    this.amount,
    this.name,
    this.description,
    this.contact,
    this.email,
  });
}
