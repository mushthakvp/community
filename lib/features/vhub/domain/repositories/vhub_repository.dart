import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/idea_entity.dart';

abstract class VHubRepository {
  Future<Either<Failure, List<IdeaEntity>>> getIdeas({
    String? status,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, IdeaEntity>> getIdeaDetails(String ideaId);

  Future<Either<Failure, IdeaEntity>> createIdea(CreateIdeaParams params);

  Future<Either<Failure, IdeaEntity>> updateIdea(UpdateIdeaParams params);

  Future<Either<Failure, bool>> deleteIdea(String ideaId);

  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    String? search,
    int page = 1,
    int limit = 10,
  });
}

class CreateIdeaParams extends Equatable {
  final String projectName;
  final List<FounderParams> founders;
  final String summaryOfIdea;
  final String longOfDevelopmentProgress;
  final String helpNeed;
  final String aboutProject;
  final String reasonForDoingProject;
  final String whoWillBuy;
  final bool isConnectedWithFoundersWork;
  final List<SignatureParams> foundersSignature;

  const CreateIdeaParams({
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
  });

  @override
  List<Object> get props => [
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
  ];
}

class UpdateIdeaParams extends CreateIdeaParams {
  final String id;

  const UpdateIdeaParams({
    required this.id,
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
  });

  @override
  List<Object> get props => [id, ...super.props];
}

class FounderParams extends Equatable {
  final String name;
  final String email;
  final String contact;
  final String affiliation;

  const FounderParams({
    required this.name,
    required this.email,
    required this.contact,
    required this.affiliation,
  });

  @override
  List<Object> get props => [name, email, contact, affiliation];
}

class SignatureParams extends Equatable {
  final String name;
  final String signature;

  const SignatureParams({required this.name, required this.signature});

  @override
  List<Object> get props => [name, signature];
}
