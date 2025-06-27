class UserDetailsModel {
  bool? status;
  String? message;
  UserDetails? userDetails;
  List<Banner>? banners;
  String? marquee;
  String? stateEmail;
  bool? isSpinned;

  UserDetailsModel({
    this.status,
    this.message,
    this.userDetails,
    this.banners,
    this.isSpinned,
    this.marquee,
    this.stateEmail,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        status: json["status"],
        message: json["message"],
        userDetails: json["userDetails"] == null
            ? null
            : UserDetails.fromJson(json["userDetails"]),
        banners: json["banners"] == null
            ? []
            : List<Banner>.from(
                json["banners"]!.map((x) => Banner.fromJson(x)),
              ),
        isSpinned: json["isSpinned"],
        marquee: json["marquee"],
        stateEmail: json["stateEmail"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userDetails": userDetails?.toJson(),
  };
}

class UserDetails {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  String? tier;
  int? loyalityPoints;
  double? walletAmount;
  String? currencyCode;
  String? communityId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.tier,
    this.loyalityPoints,
    this.walletAmount,
    this.currencyCode,
    this.communityId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    tier: json["tier"],
    loyalityPoints: json["loyalityPoints"],
    walletAmount: json["walletAmount"]?.toDouble(),
    currencyCode: json["currencyCode"],
    communityId: json["communityId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "profileImage": profileImage,
    "tier": tier,
    "loyalityPoints": loyalityPoints,
    "walletAmount": walletAmount,
    "currencyCode": currencyCode,
    "communityId": communityId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Banner {
  String? id;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Banner({
    this.id,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["_id"],
    image: json["image"],
    type: json["type"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "type": type,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
