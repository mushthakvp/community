import '../../domain/entities/idea_entity.dart';

class IdeaModel extends IdeaEntity {
  const IdeaModel({
    required super.id,
    required super.projectName,
    required super.founders,
    required super.summaryOfIdea,
    required super.longOfDevelopmentProgress,
    required super.helpNeed,
    required super.aboutProject,
    required super.reasonForDoingProject,
    required super.whoWillBuy,
    required super.isConnectedWithFoundersWork,
    required super.foundersSignature,
    required super.currentStatus,
    super.rejectReason,
    super.rejectCount,
    super.reApplyCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory IdeaModel.fromJson(Map<String, dynamic> json) {
    return IdeaModel(
      id: json['_id'] ?? '',
      projectName: json['projectName'] ?? '',
      founders:
          (json['founders'] as List<dynamic>?)
              ?.map((e) => FounderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      summaryOfIdea: json['summaryOfIdea'] ?? '',
      longOfDevelopmentProgress: json['longOfDevelopmentProgress'] ?? '',
      helpNeed: json['helpNeed'] ?? '',
      aboutProject: json['aboutProject'] ?? '',
      reasonForDoingProject: json['reasonForDoingProject'] ?? '',
      whoWillBuy: json['whoWillBuy'] ?? '',
      isConnectedWithFoundersWork: json['isConnectedWithFoundersWork'] ?? false,
      foundersSignature:
          (json['foundersSignature'] as List<dynamic>?)
              ?.map(
                (e) =>
                    FounderSignatureModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      currentStatus: json['currentStatus'] ?? 'Requested',
      rejectReason: json['rejectReason'],
      rejectCount: json['rejectCount'] ?? 0,
      reApplyCount: json['reApplyCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'projectName': projectName,
      'founders': founders.map((e) => (e as FounderModel).toJson()).toList(),
      'summaryOfIdea': summaryOfIdea,
      'longOfDevelopmentProgress': longOfDevelopmentProgress,
      'helpNeed': helpNeed,
      'aboutProject': aboutProject,
      'reasonForDoingProject': reasonForDoingProject,
      'whoWillBuy': whoWillBuy,
      'isConnectedWithFoundersWork': isConnectedWithFoundersWork,
      'foundersSignature': foundersSignature
          .map((e) => (e as FounderSignatureModel).toJson())
          .toList(),
      'currentStatus': currentStatus,
      'rejectReason': rejectReason,
      'rejectCount': rejectCount,
      'reApplyCount': reApplyCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FounderModel extends FounderEntity {
  const FounderModel({
    required super.id,
    required super.name,
    required super.email,
    required super.contact,
    required super.affiliation,
  });

  factory FounderModel.fromJson(Map<String, dynamic> json) {
    return FounderModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      affiliation: json['affiliation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'affiliation': affiliation,
    };
  }
}

class FounderSignatureModel extends FounderSignatureEntity {
  const FounderSignatureModel({
    required super.id,
    required super.name,
    required super.signature,
  });

  factory FounderSignatureModel.fromJson(Map<String, dynamic> json) {
    return FounderSignatureModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      signature: json['signature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'signature': signature};
  }
}

class FaqModel extends FaqEntity {
  const FaqModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
