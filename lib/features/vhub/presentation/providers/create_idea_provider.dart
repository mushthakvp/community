import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/idea_entity.dart';
import '../../domain/repositories/vhub_repository.dart';

class CreateIdeaProvider extends ChangeNotifier {
  // Form Controllers
  final nameController = TextEditingController();
  final summaryController = TextEditingController();
  final developmentController = TextEditingController();
  final helpController = TextEditingController();
  final aboutController = TextEditingController();
  final reasonController = TextEditingController();
  final buyController = TextEditingController();

  // Founder Controllers
  List<FounderController> _founderControllers = [FounderController(index: 0)];

  // Signature Controllers
  List<SignatureController> _signatureControllers = [SignatureController()];

  // State
  bool _isConnectedWithFoundersWork = false;
  bool _isReapply = false;
  String reapplyProjectId = '';
  int _currentStep = 0;
  bool _isUploading = false;

  // Getters
  List<FounderController> get founderControllers => _founderControllers;
  List<SignatureController> get signatureControllers => _signatureControllers;
  bool get isConnectedWithFoundersWork => _isConnectedWithFoundersWork;
  bool get isReapply => _isReapply;
  int get currentStep => _currentStep;
  bool get isUploading => _isUploading;
  int get totalSteps => 8;

  @override
  void dispose() {
    nameController.dispose();
    summaryController.dispose();
    developmentController.dispose();
    helpController.dispose();
    aboutController.dispose();
    reasonController.dispose();
    buyController.dispose();

    for (final controller in _founderControllers) {
      controller.dispose();
    }

    for (final controller in _signatureControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Navigation
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Founder Management
  void addFounder() {
    _founderControllers.add(
      FounderController(index: _founderControllers.length),
    );
    notifyListeners();
  }

  void removeFounder(int index) {
    if (_founderControllers.length > 1 && index < _founderControllers.length) {
      _founderControllers[index].dispose();
      _founderControllers.removeAt(index);

      // Update indices
      for (int i = 0; i < _founderControllers.length; i++) {
        _founderControllers[i].index = i;
      }

      notifyListeners();
    }
  }

  void setFounderAffiliation(int index, String affiliation) {
    if (index < _founderControllers.length) {
      _founderControllers[index].affiliation = affiliation;
      notifyListeners();
    }
  }

  // Signature Management
  void addSignature() {
    _signatureControllers.add(SignatureController());
    notifyListeners();
  }

  void removeSignature(int index) {
    if (_signatureControllers.length > 1 &&
        index < _signatureControllers.length) {
      _signatureControllers[index].dispose();
      _signatureControllers.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> uploadDocument(int index) async {
    try {
      _isUploading = true;
      notifyListeners();
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (index < _signatureControllers.length) {
          _signatureControllers[index].documentPath = file.path;
          _signatureControllers[index].documentUrl = file.path;
        }
      }
    } catch (e) {
      debugPrint('Error uploading document: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // Form State
  void setConnectedWithFoundersWork(bool value) {
    _isConnectedWithFoundersWork = value;
    notifyListeners();
  }

  // Validation
  bool validateStep(int step) {
    switch (step) {
      case 0: // Project name and founders
        return _validateProjectAndFounders();
      case 1: // Summary
        return summaryController.text.trim().isNotEmpty;
      case 2: // Development progress
        return developmentController.text.trim().isNotEmpty;
      case 3: // Help needed
        return helpController.text.trim().isNotEmpty;
      case 4: // About project
        return aboutController.text.trim().isNotEmpty;
      case 5: // Reason for doing project
        return reasonController.text.trim().isNotEmpty;
      case 6: // Who will buy
        return buyController.text.trim().isNotEmpty;
      case 7: // Signatures
        return _validateSignatures();
      default:
        return false;
    }
  }

  bool _validateProjectAndFounders() {
    if (nameController.text.trim().isEmpty) return false;

    for (final founder in _founderControllers) {
      if (!founder.isValid) return false;
    }

    return true;
  }

  bool _validateSignatures() {
    for (final signature in _signatureControllers) {
      if (!signature.isValid) return false;
    }
    return true;
  }

  // Create Idea Params
  CreateIdeaParams buildCreateIdeaParams() {
    return CreateIdeaParams(
      projectName: nameController.text.trim(),
      founders: _founderControllers
          .map(
            (f) => FounderParams(
              name: f.nameController.text.trim(),
              email: f.emailController.text.trim(),
              contact: f.contactController.text.trim(),
              affiliation: f.affiliation,
            ),
          )
          .toList(),
      summaryOfIdea: summaryController.text.trim(),
      longOfDevelopmentProgress: developmentController.text.trim(),
      helpNeed: helpController.text.trim(),
      aboutProject: aboutController.text.trim(),
      reasonForDoingProject: reasonController.text.trim(),
      whoWillBuy: buyController.text.trim(),
      isConnectedWithFoundersWork: _isConnectedWithFoundersWork,
      foundersSignature: _signatureControllers
          .map(
            (s) => SignatureParams(
              name: s.nameController.text.trim(),
              signature: s.documentUrl ?? '',
            ),
          )
          .toList(),
    );
  }

  // Reset
  void reset() {
    nameController.clear();
    summaryController.clear();
    developmentController.clear();
    helpController.clear();
    aboutController.clear();
    reasonController.clear();
    buyController.clear();

    // Reset founders
    for (final controller in _founderControllers) {
      controller.dispose();
    }
    _founderControllers = [FounderController(index: 0)];

    // Reset signatures
    for (final controller in _signatureControllers) {
      controller.dispose();
    }
    _signatureControllers = [SignatureController()];

    _isConnectedWithFoundersWork = false;
    _isReapply = false;
    reapplyProjectId = '';
    _currentStep = 0;

    notifyListeners();
  }

  // Reapply functionality
  void setReapplyData(IdeaEntity idea) {
    _isReapply = true;
    reapplyProjectId = idea.id;

    nameController.text = idea.projectName;
    summaryController.text = idea.summaryOfIdea;
    developmentController.text = idea.longOfDevelopmentProgress;
    helpController.text = idea.helpNeed;
    aboutController.text = idea.aboutProject;
    reasonController.text = idea.reasonForDoingProject;
    buyController.text = idea.whoWillBuy;
    _isConnectedWithFoundersWork = idea.isConnectedWithFoundersWork;

    // Set founders
    for (final controller in _founderControllers) {
      controller.dispose();
    }
    _founderControllers = idea.founders.asMap().entries.map((entry) {
      final founder = entry.value;
      return FounderController(
        index: entry.key,
        initialName: founder.name,
        initialEmail: founder.email,
        initialContact: founder.contact,
        initialAffiliation: founder.affiliation,
      );
    }).toList();

    // Set signatures
    for (final controller in _signatureControllers) {
      controller.dispose();
    }
    _signatureControllers = idea.foundersSignature.map((signature) {
      return SignatureController(
        initialName: signature.name,
        initialDocumentUrl: signature.signature,
      );
    }).toList();

    notifyListeners();
  }
}

class FounderController {
  int index;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  String affiliation;

  FounderController({
    required this.index,
    String? initialName,
    String? initialEmail,
    String? initialContact,
    String? initialAffiliation,
  }) : nameController = TextEditingController(text: initialName),
       emailController = TextEditingController(text: initialEmail),
       contactController = TextEditingController(text: initialContact),
       affiliation = initialAffiliation ?? '';

  bool get isValid {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    );

    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        emailRegex.hasMatch(emailController.text.trim()) &&
        contactController.text.trim().isNotEmpty &&
        affiliation.isNotEmpty;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
  }
}

class SignatureController {
  final TextEditingController nameController;
  String? documentPath;
  String? documentUrl;

  SignatureController({String? initialName, String? initialDocumentUrl})
    : nameController = TextEditingController(text: initialName),
      documentUrl = initialDocumentUrl;

  bool get isValid {
    return nameController.text.trim().isNotEmpty &&
        (documentUrl != null && documentUrl!.isNotEmpty);
  }

  void dispose() {
    nameController.dispose();
  }
}
