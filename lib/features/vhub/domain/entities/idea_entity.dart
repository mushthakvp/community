import 'package:equatable/equatable.dart';

class IdeaEntity extends Equatable {
  final String id;
  final String projectName;
  final List<FounderEntity> founders;
  final String summaryOfIdea;
  final String longOfDevelopmentProgress;
  final String helpNeed;
  final String aboutProject;
  final String reasonForDoingProject;
  final String whoWillBuy;
  final bool isConnectedWithFoundersWork;
  final List<FounderSignatureEntity> foundersSignature;
  final String currentStatus;
  final String? rejectReason;
  final int rejectCount;
  final int reApplyCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IdeaEntity({
    required this.id,
    required this.projectName,
    required this.founders,
    required this.summaryOfIdea,
    required this.longOfDevelopmentProgress,
    required this.helpNeed,
    required this.aboutProject,
    required this.reasonForDoingProject,
    required this.whoWillBuy,
    required this.isConnectedWithFoundersWork,
    required this.foundersSignature,
    required this.currentStatus,
    this.rejectReason,
    this.rejectCount = 0,
    this.reApplyCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  IdeaEntity copyWith({
    String? id,
    String? projectName,
    List<FounderEntity>? founders,
    String? summaryOfIdea,
    String? longOfDevelopmentProgress,
    String? helpNeed,
    String? aboutProject,
    String? reasonForDoingProject,
    String? whoWillBuy,
    bool? isConnectedWithFoundersWork,
    List<FounderSignatureEntity>? foundersSignature,
    String? currentStatus,
    String? rejectReason,
    int? rejectCount,
    int? reApplyCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IdeaEntity(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      founders: founders ?? this.founders,
      summaryOfIdea: summaryOfIdea ?? this.summaryOfIdea,
      longOfDevelopmentProgress:
          longOfDevelopmentProgress ?? this.longOfDevelopmentProgress,
      helpNeed: helpNeed ?? this.helpNeed,
      aboutProject: aboutProject ?? this.aboutProject,
      reasonForDoingProject:
          reasonForDoingProject ?? this.reasonForDoingProject,
      whoWillBuy: whoWillBuy ?? this.whoWillBuy,
      isConnectedWithFoundersWork:
          isConnectedWithFoundersWork ?? this.isConnectedWithFoundersWork,
      foundersSignature: foundersSignature ?? this.foundersSignature,
      currentStatus: currentStatus ?? this.currentStatus,
      rejectReason: rejectReason ?? this.rejectReason,
      rejectCount: rejectCount ?? this.rejectCount,
      reApplyCount: reApplyCount ?? this.reApplyCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAccepted => currentStatus.toLowerCase() == 'accepted';
  bool get isRejected => currentStatus.toLowerCase() == 'rejected';
  bool get isRequested => currentStatus.toLowerCase() == 'requested';

  @override
  List<Object?> get props => [
    id,
    projectName,
    founders,
    summaryOfIdea,
    longOfDevelopmentProgress,
    helpNeed,
    aboutProject,
    reasonForDoingProject,
    whoWillBuy,
    isConnectedWithFoundersWork,
    foundersSignature,
    currentStatus,
    rejectReason,
    rejectCount,
    reApplyCount,
    createdAt,
    updatedAt,
  ];
}

class FounderEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String contact;
  final String affiliation;

  const FounderEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.affiliation,
  });

  @override
  List<Object> get props => [id, name, email, contact, affiliation];
}

class FounderSignatureEntity extends Equatable {
  final String id;
  final String name;
  final String signature;

  const FounderSignatureEntity({
    required this.id,
    required this.name,
    required this.signature,
  });

  @override
  List<Object> get props => [id, name, signature];
}

class FaqEntity extends Equatable {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FaqEntity({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, question, answer, createdAt, updatedAt];
}
