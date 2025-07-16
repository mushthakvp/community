import 'package:flutter/material.dart';

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

  factory IdeaModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data cannot be null');
    }

    try {
      // Handle different possible ID field names
      String id = '';
      if (json.containsKey('_id')) {
        final idValue = json['_id'];
        if (idValue is Map && idValue.containsKey('\$oid')) {
          id = idValue['\$oid'].toString();
        } else {
          id = idValue?.toString() ?? '';
        }
      } else if (json.containsKey('id')) {
        id = json['id']?.toString() ?? '';
      }

      // If still no ID, generate a temporary one
      if (id.isEmpty) {
        id = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Determine current status from the API response
      String currentStatus = 'Requested';
      if (json.containsKey('currentStatus')) {
        currentStatus = json['currentStatus']?.toString() ?? 'Requested';
      } else {
        // Fallback to checking boolean flags
        if (json['isAccepted'] == true) {
          currentStatus = 'Accepted';
        } else if (json['isRejected'] == true) {
          currentStatus = 'Rejected';
        }
      }

      return IdeaModel(
        id: id,
        projectName: json['projectName']?.toString() ?? '',
        founders: _parseFounders(json['founders']),
        summaryOfIdea: json['summaryOfIdea']?.toString() ?? '',
        longOfDevelopmentProgress:
            json['longOfDevelopmentProgress']?.toString() ?? '',
        helpNeed: json['helpNeed']?.toString() ?? '',
        aboutProject: json['aboutProject']?.toString() ?? '',
        reasonForDoingProject: json['reasonForDoingProject']?.toString() ?? '',
        whoWillBuy: json['whoWillBuy']?.toString() ?? '',
        isConnectedWithFoundersWork:
            json['isConnectedWithFoundersWork'] == true,
        foundersSignature: _parseFounderSignatures(json['foundersSignature']),
        currentStatus: currentStatus,
        rejectReason: json['rejectReason']?.toString(),
        rejectCount: _parseInt(json['rejectCount']) ?? 0,
        reApplyCount: _parseInt(json['reApplyCount']) ?? 0,
        createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
        updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error parsing IdeaModel from JSON: $e');
      debugPrint('JSON data: $json');
      rethrow;
    }
  }

  static List<FounderModel> _parseFounders(dynamic foundersData) {
    if (foundersData == null) return [];

    try {
      if (foundersData is List) {
        return foundersData
            .where((e) => e != null)
            .map((e) => FounderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error parsing founders: $e');
    }

    return [];
  }

  static List<FounderSignatureModel> _parseFounderSignatures(
    dynamic signaturesData,
  ) {
    if (signaturesData == null) return [];

    try {
      if (signaturesData is List) {
        return signaturesData
            .where((e) => e != null)
            .map(
              (e) => FounderSignatureModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('Error parsing founder signatures: $e');
    }

    return [];
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
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

  factory FounderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Founder JSON data cannot be null');
    }

    // Handle different possible ID field names
    String id = '';
    if (json.containsKey('_id')) {
      final idValue = json['_id'];
      if (idValue is Map && idValue.containsKey('\$oid')) {
        id = idValue['\$oid'].toString();
      } else {
        id = idValue?.toString() ?? '';
      }
    } else if (json.containsKey('id')) {
      id = json['id']?.toString() ?? '';
    }

    return FounderModel(
      id: id,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      affiliation: json['affiliation']?.toString() ?? '',
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

  factory FounderSignatureModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Founder signature JSON data cannot be null');
    }

    // Handle different possible ID field names
    String id = '';
    if (json.containsKey('_id')) {
      final idValue = json['_id'];
      if (idValue is Map && idValue.containsKey('\$oid')) {
        id = idValue['\$oid'].toString();
      } else {
        id = idValue?.toString() ?? '';
      }
    } else if (json.containsKey('id')) {
      id = json['id']?.toString() ?? '';
    }

    return FounderSignatureModel(
      id: id,
      name: json['name']?.toString() ?? '',
      signature: json['signature']?.toString() ?? '',
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

  factory FaqModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('FAQ JSON data cannot be null');
    }

    // Handle different possible ID field names
    String id = '';
    if (json.containsKey('_id')) {
      id = json['_id']?.toString() ?? '';
    } else if (json.containsKey('id')) {
      id = json['id']?.toString() ?? '';
    }

    return FaqModel(
      id: id,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
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
