import '../../domain/entities/wallet_recharge_entity.dart';

class WalletRechargeModel extends WalletRechargeEntity {
  const WalletRechargeModel({
    super.success,
    super.order,
    super.currency,
    super.options,
  });

  factory WalletRechargeModel.fromJson(Map<String, dynamic> json) {
    return WalletRechargeModel(
      success: json["success"],
      order: json["order"] == null ? null : OrderModel.fromJson(json["order"]),
      currency: json["currency"],
      options: json["options"] == null
          ? null
          : PaymentOptionsModel.fromJson(json["options"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "order": order != null ? (order as OrderModel).toJson() : null,
      "currency": currency,
      "options": options != null
          ? (options as PaymentOptionsModel).toJson()
          : null,
    };
  }

  WalletRechargeEntity toEntity() {
    return WalletRechargeEntity(
      success: success,
      order: (order as OrderModel?)?.toEntity(),
      currency: currency,
      options: (options as PaymentOptionsModel?)?.toEntity(),
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    super.amount,
    super.amountDue,
    super.amountPaid,
    super.attempts,
    super.createdAt,
    super.currency,
    super.entity,
    super.id,
    super.notes,
    super.offerId,
    super.receipt,
    super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      amount: json["amount"],
      amountDue: json["amount_due"],
      amountPaid: json["amount_paid"],
      attempts: json["attempts"],
      createdAt: json["created_at"],
      currency: json["currency"],
      entity: json["entity"],
      id: json["id"],
      notes: json["notes"] == null
          ? []
          : List<dynamic>.from(json["notes"]!.map((x) => x)),
      offerId: json["offer_id"],
      receipt: json["receipt"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "amount_due": amountDue,
      "amount_paid": amountPaid,
      "attempts": attempts,
      "created_at": createdAt,
      "currency": currency,
      "entity": entity,
      "id": id,
      "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
      "offer_id": offerId,
      "receipt": receipt,
      "status": status,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      amount: amount,
      amountDue: amountDue,
      amountPaid: amountPaid,
      attempts: attempts,
      createdAt: createdAt,
      currency: currency,
      entity: entity,
      id: id,
      notes: notes,
      offerId: offerId,
      receipt: receipt,
      status: status,
    );
  }
}

class PaymentOptionsModel extends PaymentOptionsEntity {
  const PaymentOptionsModel({
    super.key,
    super.amount,
    super.name,
    super.description,
    super.contact,
    super.email,
  });

  factory PaymentOptionsModel.fromJson(Map<String, dynamic> json) {
    return PaymentOptionsModel(
      key: json["key"],
      amount: json["amount"],
      name: json["name"],
      description: json["description"],
      contact: json["contact"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "amount": amount,
      "name": name,
      "description": description,
      "contact": contact,
      "email": email,
    };
  }

  PaymentOptionsEntity toEntity() {
    return PaymentOptionsEntity(
      key: key,
      amount: amount,
      name: name,
      description: description,
      contact: contact,
      email: email,
    );
  }
}
