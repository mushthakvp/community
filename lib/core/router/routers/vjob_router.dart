import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/vjob/my_company/presentation/pages/empty_company_page.dart';
import '../../../features/vjob/my_company/presentation/pages/success_company_page.dart';
import '../../constants/route_constants.dart';

class VJobRouter {
  /// VJob job platform related routes
  static List<RouteBase> get routes => [
    // ==================== VJOB HOME ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobHome,
      name: 'vjobHome',
      builder: (context, state) => _buildPlaceholderPage('VJob Home'),
    ),

    // ==================== VJOB JOB DETAILS ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vjobJobDetails}/:jobId',
      name: 'vjobJobDetails',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return _buildPlaceholderPage('Job Details: $jobId');
      },
    ),

    // ==================== VJOB CREATE JOB ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobCreateJob,
      name: 'vjobCreateJob',
      builder: (context, state) => _buildPlaceholderPage('Create Job'),
    ),

    // ==================== VJOB MY JOBS ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobMyJobs,
      name: 'vjobMyJobs',
      builder: (context, state) => _buildPlaceholderPage('My Jobs'),
    ),

    // ==================== VJOB APPLICATIONS ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobApplications,
      name: 'vjobApplications',
      builder: (context, state) => _buildPlaceholderPage('Applications'),
    ),

    // ==================== VJOB SAVED JOBS ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobSavedJobs,
      name: 'vjobSavedJobs',
      builder: (context, state) => _buildPlaceholderPage('Saved Jobs'),
    ),

    // ==================== VJOB SEARCH ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobSearch,
      name: 'vjobSearch',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final query = queryParams['q'];
        return _buildPlaceholderPage(
          'Job Search${query != null ? ' - $query' : ''}',
        );
      },
    ),

    // ==================== VJOB COMPANIES ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobCompanies,
      name: 'vjobCompanies',
      builder: (context, state) => _buildPlaceholderPage('Companies'),
    ),

    // ==================== VJOB CREATE COMPANY ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobCreateCompany,
      name: 'vjobCreateCompany',
      builder: (context, state) => _buildPlaceholderPage('Create Company'),
    ),

    // ==================== VJOB POSTS ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobPosts,
      name: 'vjobPosts',
      builder: (context, state) => _buildPlaceholderPage('Posts'),
    ),

    // ==================== VJOB CREATE POST ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobCreatePost,
      name: 'vjobCreatePost',
      builder: (context, state) => _buildPlaceholderPage('Create Post'),
    ),

    // ==================== VJOB COMPANY MANAGEMENT ROUTES ====================
    GoRoute(
      path: '/vjob/empty-company',
      name: 'vjobEmptyCompany',
      builder: (context, state) => const EmptyCompanyPage(),
    ),
    GoRoute(
      path: '/vjob/success-company',
      name: 'vjobSuccessCompany',
      builder: (context, state) => const SuccessCompanyPage(),
    ),
  ];

  /// Helper method to build placeholder pages for VJob features
  static Widget _buildPlaceholderPage(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is coming soon!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Route paths constants
  static const String vjobHomePath = RouteConstants.vjobHome;
  static const String vjobJobDetailsPath = RouteConstants.vjobJobDetails;
  static const String vjobCreateJobPath = RouteConstants.vjobCreateJob;
  static const String vjobMyJobsPath = RouteConstants.vjobMyJobs;
  static const String vjobApplicationsPath = RouteConstants.vjobApplications;
  static const String vjobSavedJobsPath = RouteConstants.vjobSavedJobs;
  static const String vjobSearchPath = RouteConstants.vjobSearch;
  static const String vjobCompaniesPath = RouteConstants.vjobCompanies;
  static const String vjobCreateCompanyPath = RouteConstants.vjobCreateCompany;
  static const String vjobPostsPath = RouteConstants.vjobPosts;
  static const String vjobCreatePostPath = RouteConstants.vjobCreatePost;

  /// Helper methods for VJob navigation
  static String buildJobDetailsRoute(String jobId) {
    return '${RouteConstants.vjobJobDetails}/$jobId';
  }

  static String buildJobSearchRoute({
    String? query,
    String? location,
    String? workStyle,
  }) {
    final queryParams = <String, String>{};

    if (query != null && query.isNotEmpty) {
      queryParams['q'] = Uri.encodeComponent(query);
    }
    if (location != null) {
      queryParams['location'] = Uri.encodeComponent(location);
    }
    if (workStyle != null) {
      queryParams['workStyle'] = Uri.encodeComponent(workStyle);
    }

    if (queryParams.isEmpty) return RouteConstants.vjobSearch;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${RouteConstants.vjobSearch}?$queryString';
  }
}
