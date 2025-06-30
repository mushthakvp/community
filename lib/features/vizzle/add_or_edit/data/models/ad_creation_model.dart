class AdCreationModel {
  final String? district;
  final String? title;
  final String? description;
  final List<String>? images;
  final String? category;
  final String? subCategory;
  final String? subSubcategory;
  final String? subItem;
  final String? latitude;
  final String? longitude;
  final String? address;
  final double? price;
  final String? phone;
  final String? fuelType;
  final String? color;
  final String? transmissionType;
  final String? usage;
  final String? condition;
  final String? sellerType;
  final String? warranty;
  final String? brand;
  final String? memory;
  final String? processor;
  final String? hardDrive;
  final String? type;
  final String? duration;
  final String? rating;
  final String? model;
  final String? damage;
  final String? damageDetails;
  final String? materials;
  final String? batteryPercentage;
  final String? version;
  final String? accompaniments;
  final bool? carrierLock;
  final String? imeiNumber;
  final String? storageCapacity;
  final String? memoryRam;
  final String? numberOfTickets;
  final String? quantity;
  final int? year;
  final double? kilometers;
  final double? engineCapacity;
  final List<String>? extras;

  const AdCreationModel({
    this.district,
    this.title,
    this.description,
    this.images,
    this.category,
    this.subCategory,
    this.subSubcategory,
    this.subItem,
    this.latitude,
    this.longitude,
    this.address,
    this.price,
    this.phone,
    this.fuelType,
    this.color,
    this.transmissionType,
    this.usage,
    this.condition,
    this.sellerType,
    this.warranty,
    this.brand,
    this.memory,
    this.processor,
    this.hardDrive,
    this.type,
    this.duration,
    this.rating,
    this.model,
    this.damage,
    this.damageDetails,
    this.materials,
    this.batteryPercentage,
    this.version,
    this.accompaniments,
    this.carrierLock,
    this.imeiNumber,
    this.storageCapacity,
    this.memoryRam,
    this.numberOfTickets,
    this.quantity,
    this.year,
    this.kilometers,
    this.engineCapacity,
    this.extras,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (district != null) data['district'] = district;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (images != null) data['images'] = images;
    if (category != null) data['category'] = category;
    if (subCategory != null) data['subCategory'] = subCategory;
    if (subSubcategory != null) data['subSubcategory'] = subSubcategory;
    if (subItem != null) data['subItem'] = subItem;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (address != null) data['address'] = address;
    if (price != null) data['price'] = price;
    if (phone != null) data['phone'] = phone;
    if (fuelType != null) data['fuelType'] = fuelType;
    if (color != null) data['color'] = color;
    if (transmissionType != null) data['transmissionType'] = transmissionType;
    if (usage != null) data['usage'] = usage;
    if (condition != null) data['condition'] = condition;
    if (sellerType != null) data['sellerType'] = sellerType;
    if (warranty != null) data['warranty'] = warranty;
    if (brand != null) data['brand'] = brand;
    if (memory != null) data['memory'] = memory;
    if (processor != null) data['processor'] = processor;
    if (hardDrive != null) data['hardDrive'] = hardDrive;
    if (type != null) data['type'] = type;
    if (duration != null) data['duration'] = duration;
    if (rating != null) data['rating'] = rating;
    if (model != null) data['model'] = model;
    if (damage != null) data['damage'] = damage;
    if (damageDetails != null) data['damageDetails'] = damageDetails;
    if (materials != null) data['materials'] = materials;
    if (batteryPercentage != null) {
      data['batteryPercentage'] = batteryPercentage;
    }
    if (version != null) data['version'] = version;
    if (accompaniments != null) data['accompaniments'] = accompaniments;
    if (carrierLock != null) data['carrierLock'] = carrierLock;
    if (imeiNumber != null) data['imeiNumber'] = imeiNumber;
    if (storageCapacity != null) data['storageCapacity'] = storageCapacity;
    if (memoryRam != null) data['memoryRam'] = memoryRam;
    if (numberOfTickets != null) data['numberOfTickets'] = numberOfTickets;
    if (quantity != null) data['quantity'] = quantity;
    if (year != null) data['year'] = year;
    if (kilometers != null) data['kilometers'] = kilometers;
    if (engineCapacity != null) data['engineCapacity'] = engineCapacity;
    if (extras != null) data['extras'] = extras;

    return data;
  }
}
