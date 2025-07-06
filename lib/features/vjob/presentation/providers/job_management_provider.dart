import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/vjob_repository.dart';

enum JobManagementStatus { initial, loading, loaded, error }

class JobManagementProvider extends ChangeNotifier {
  final VJobRepository _repository;

  JobManagementProvider({required VJobRepository repository})
    : _repository = repository;

  // State
  JobManagementStatus _status = JobManagementStatus.initial;
  List<JobEntity> _myJobs = [];
  JobEntity? _selectedJob;
  String? _errorMessage;

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final minimumSalaryController = TextEditingController();

  // Form State
  String _selectedCompanyId = '';
  String _selectedCity = '';
  String _selectedState = '';
  String _selectedWorkStyle = '';
  String _selectedEducation = '';
  List<String> _selectedPositions = [];
  List<String> _selectedSchedule = [];
  List<String> _selectedBenefits = [];
  List<String> _selectedSkills = [];
  List<String> _selectedLanguages = [];
  List<String> _responsibilities = [];

  // Getters
  JobManagementStatus get status => _status;
  List<JobEntity> get myJobs => _myJobs;
  JobEntity? get selectedJob => _selectedJob;
  String? get errorMessage => _errorMessage;
  String get selectedCompanyId => _selectedCompanyId;
  String get selectedCity => _selectedCity;
  String get selectedState => _selectedState;
  String get selectedWorkStyle => _selectedWorkStyle;
  String get selectedEducation => _selectedEducation;
  List<String> get selectedPositions => _selectedPositions;
  List<String> get selectedSchedule => _selectedSchedule;
  List<String> get selectedBenefits => _selectedBenefits;
  List<String> get selectedSkills => _selectedSkills;
  List<String> get selectedLanguages => _selectedLanguages;
  List<String> get responsibilities => _responsibilities;
  bool get isLoading => _status == JobManagementStatus.loading;
  bool get hasError => _status == JobManagementStatus.error;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    minimumSalaryController.dispose();
    super.dispose();
  }

  // Public Methods
  Future<void> loadMyJobs() async {
    _setLoading();
    try {
      // This would typically call a getMyJobs method
      // For now, using the general getJobs method
      final result = await _repository.getJobs();
      result.fold((failure) => _setError(failure.message), (jobs) {
        _myJobs = jobs;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading my jobs: $e');
      _setError('Failed to load jobs. Please try again.');
    }
  }

  Future<void> createJob() async {
    if (!_validateJobForm()) return;

    _setLoading();
    try {
      final params = CreateJobParams(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        companyId: _selectedCompanyId,
        city: _selectedCity,
        state: _selectedState,
        workStyle: _selectedWorkStyle,
        position: _selectedPositions,
        schedule: _selectedSchedule,
        benefits: _selectedBenefits,
        minimumSalary: int.tryParse(minimumSalaryController.text) ?? 0,
        education: _selectedEducation,
        skills: _selectedSkills,
        languages: _selectedLanguages,
        responsibilities: _responsibilities,
      );

      final result = await _repository.createJob(params);
      result.fold((failure) => _setError(failure.message), (job) {
        _myJobs.insert(0, job);
        _clearForm();
        _setLoaded();
        _showSuccess('Job created successfully');
      });
    } catch (e) {
      dev.log('Error creating job: $e');
      _setError('Failed to create job. Please try again.');
    }
  }

  Future<void> updateJob(String jobId) async {
    if (!_validateJobForm()) return;

    _setLoading();
    try {
      final params = CreateJobParams(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        companyId: _selectedCompanyId,
        city: _selectedCity,
        state: _selectedState,
        workStyle: _selectedWorkStyle,
        position: _selectedPositions,
        schedule: _selectedSchedule,
        benefits: _selectedBenefits,
        minimumSalary: int.tryParse(minimumSalaryController.text) ?? 0,
        education: _selectedEducation,
        skills: _selectedSkills,
        languages: _selectedLanguages,
        responsibilities: _responsibilities,
      );

      final result = await _repository.updateJob(jobId, params);
      result.fold((failure) => _setError(failure.message), (job) {
        final index = _myJobs.indexWhere((j) => j.id == jobId);
        if (index != -1) {
          _myJobs[index] = job;
        }
        _setLoaded();
        _showSuccess('Job updated successfully');
      });
    } catch (e) {
      dev.log('Error updating job: $e');
      _setError('Failed to update job. Please try again.');
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      final result = await _repository.deleteJob(jobId);
      result.fold((failure) => _setError(failure.message), (success) {
        if (success) {
          _myJobs.removeWhere((job) => job.id == jobId);
          notifyListeners();
          _showSuccess('Job deleted successfully');
        }
      });
    } catch (e) {
      dev.log('Error deleting job: $e');
      _setError('Failed to delete job. Please try again.');
    }
  }

  void setSelectedJob(JobEntity job) {
    _selectedJob = job;
    _populateFormFromJob(job);
    notifyListeners();
  }

  void clearSelectedJob() {
    _selectedJob = null;
    _clearForm();
    notifyListeners();
  }

  // Form Methods
  void setCompanyId(String companyId) {
    _selectedCompanyId = companyId;
    notifyListeners();
  }

  void setLocation(String city, String state) {
    _selectedCity = city;
    _selectedState = state;
    notifyListeners();
  }

  void setWorkStyle(String workStyle) {
    _selectedWorkStyle = workStyle;
    notifyListeners();
  }

  void setEducation(String education) {
    _selectedEducation = education;
    notifyListeners();
  }

  void togglePosition(String position) {
    if (_selectedPositions.contains(position)) {
      _selectedPositions.remove(position);
    } else {
      _selectedPositions.add(position);
    }
    notifyListeners();
  }

  void toggleSchedule(String schedule) {
    if (_selectedSchedule.contains(schedule)) {
      _selectedSchedule.remove(schedule);
    } else {
      _selectedSchedule.add(schedule);
    }
    notifyListeners();
  }

  void toggleBenefit(String benefit) {
    if (_selectedBenefits.contains(benefit)) {
      _selectedBenefits.remove(benefit);
    } else {
      _selectedBenefits.add(benefit);
    }
    notifyListeners();
  }

  void toggleSkill(String skill) {
    if (_selectedSkills.contains(skill)) {
      _selectedSkills.remove(skill);
    } else {
      _selectedSkills.add(skill);
    }
    notifyListeners();
  }

  void toggleLanguage(String language) {
    if (_selectedLanguages.contains(language)) {
      _selectedLanguages.remove(language);
    } else {
      _selectedLanguages.add(language);
    }
    notifyListeners();
  }

  void addResponsibility(String responsibility) {
    if (responsibility.trim().isNotEmpty &&
        !_responsibilities.contains(responsibility.trim())) {
      _responsibilities.add(responsibility.trim());
      notifyListeners();
    }
  }

  void removeResponsibility(String responsibility) {
    _responsibilities.remove(responsibility);
    notifyListeners();
  }

  // Private Methods
  void _setLoading() {
    _status = JobManagementStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = JobManagementStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = JobManagementStatus.error;
    _errorMessage = message;
    dev.log('Job management error: $message');
    notifyListeners();
  }

  void _showSuccess(String message) {
    dev.log('Success: $message');
    // You can implement success message display here
  }

  bool _validateJobForm() {
    if (titleController.text.trim().isEmpty) {
      _setError('Job title is required');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      _setError('Job description is required');
      return false;
    }

    if (_selectedCompanyId.isEmpty) {
      _setError('Company selection is required');
      return false;
    }

    if (_selectedCity.isEmpty || _selectedState.isEmpty) {
      _setError('Location is required');
      return false;
    }

    if (_selectedWorkStyle.isEmpty) {
      _setError('Work style is required');
      return false;
    }

    if (_selectedPositions.isEmpty) {
      _setError('At least one position type is required');
      return false;
    }

    if (_selectedSchedule.isEmpty) {
      _setError('At least one schedule option is required');
      return false;
    }

    return true;
  }

  void _populateFormFromJob(JobEntity job) {
    titleController.text = job.title;
    descriptionController.text = job.description;
    minimumSalaryController.text = job.minimumSalary.toString();
    _selectedCompanyId = job.company.id;
    _selectedCity = job.city;
    _selectedState = job.state;
    _selectedWorkStyle = job.workStyle;
    _selectedEducation = job.education;
    _selectedPositions = List.from(job.position);
    _selectedSchedule = List.from(job.schedule);
    _selectedBenefits = List.from(job.benefits);
    _selectedSkills = List.from(job.skills);
    _selectedLanguages = List.from(job.languages);
    _responsibilities = List.from(job.responsibilities);
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    minimumSalaryController.clear();
    _selectedCompanyId = '';
    _selectedCity = '';
    _selectedState = '';
    _selectedWorkStyle = '';
    _selectedEducation = '';
    _selectedPositions.clear();
    _selectedSchedule.clear();
    _selectedBenefits.clear();
    _selectedSkills.clear();
    _selectedLanguages.clear();
    _responsibilities.clear();
  }
}
