import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/vjob/company_job_details/presentation/pages/company_job_details_page.dart';
import '../../../features/vjob/create_company/presentation/pages/company_success_page.dart';
import '../../../features/vjob/create_company/presentation/pages/create_company_page.dart';
import '../../../features/vjob/create_job/presentation/pages/create_job_page.dart';
import '../../../features/vjob/create_post/presentation/pages/create_post_page.dart';
import '../../../features/vjob/home/presentation/pages/vjob_home_page.dart';
import '../../../features/vjob/job_details/presentation/pages/job_details_page.dart';
import '../../../features/vjob/my_company/presentation/pages/empty_company_page.dart';
import '../../../features/vjob/my_company/presentation/pages/my_company_page.dart';
import '../../../features/vjob/my_company/presentation/pages/success_company_page.dart';
import '../../../features/vjob/my_jobs/presentation/pages/my_jobs_page.dart';
import '../../../features/vjob/mypost_view/presentation/pages/my_post_view_page.dart';
import '../../../features/vjob/profile/presentation/pages/profile_page.dart';
import '../../../features/vjob/search/presentation/pages/search_page.dart';
import '../../constants/route_constants.dart';

class VJobRouter {
  /// VJob job platform related routes
  static List<RouteBase> get routes => [
    // ==================== VJOB HOME ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobHome,
      name: 'vjobHome',
      builder: (context, state) => const VJobHomePage(),
    ),

    // ==================== VJOB JOB DETAILS ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vjobJobDetails}/:jobId',
      name: 'vjobJobDetails',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return JobDetailsPage(jobId: jobId);
      },
    ),

    // ==================== VJOB CREATE JOB ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobCreateJob,
      name: 'vjobCreateJob',
      builder: (context, state) => const CreateJobPage(),
    ),

    // ==================== VJOB EDIT JOB ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vjobCreateJob}/edit/:jobId',
      name: 'vjobEditJob',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId'];
        return CreateJobPage(jobId: jobId);
      },
    ),

    // ==================== VJOB MY JOBS ROUTE ====================
    GoRoute(
      path: RouteConstants.vjobMyJobs,
      name: 'vjobMyJobs',
      builder: (context, state) => const MyJobsPage(),
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
      builder: (context, state) => const SearchPage(),
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
      builder: (context, state) => const CreateCompanyPage(),
    ),

    // ==================== VJOB EDIT COMPANY ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vjobCreateCompany}/edit',
      name: 'vjobEditCompany',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final company = extra?['company'];
        return CreateCompanyPage(company: company);
      },
    ),

    // ==================== VJOB COMPANY SUCCESS ROUTE ====================
    GoRoute(
      path: '/vjob/company/success',
      name: 'vjobCompanySuccess',
      builder: (context, state) => const CompanySuccessPage(),
    ),

    // ==================== VJOB MY COMPANY ROUTES ====================
    GoRoute(
      path: '/vjob/my-company',
      name: 'vjobMyCompany',
      builder: (context, state) => const MyCompanyPage(),
    ),

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

    // ==================== VJOB COMPANY JOB DETAILS ROUTE ====================
    GoRoute(
      path: '/vjob/company-job-details/:jobId',
      name: 'vjobCompanyJobDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final job = extra?['job'];
        return CompanyJobDetailsPage(job: job);
      },
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
      builder: (context, state) => const CreatePostPage(),
    ),

    // ==================== VJOB EDIT POST ROUTE ====================
    GoRoute(
      path: '/vjob/edit-post/:postId',
      name: 'vjobEditPost',
      builder: (context, state) {
        return CreatePostPage();
      },
    ),

    // ==================== VJOB MY POSTS ROUTE ====================
    GoRoute(
      path: '/vjob/my-posts',
      name: 'vjobMyPosts',
      builder: (context, state) => const MyPostViewPage(),
    ),

    // ==================== VJOB POST DETAIL ROUTE ====================
    GoRoute(
      path: '/vjob/post-detail/:postId',
      name: 'vjobPostDetail',
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;
        return _buildPlaceholderPage('Post Details: $postId');
      },
    ),

    // ==================== VJOB POST STATS ROUTE ====================
    GoRoute(
      path: '/vjob/post-stats',
      name: 'vjobPostStats',
      builder: (context, state) => _buildPlaceholderPage('Post Statistics'),
    ),

    // ==================== VJOB JOB APPLICATION ROUTE ====================
    GoRoute(
      path: '/vjob/apply/:jobId',
      name: 'vjobApplyJob',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return _buildPlaceholderPage('Apply for Job: $jobId');
      },
    ),

    // ==================== VJOB PROFILE ROUTE ====================
    GoRoute(
      path: '/vjob/profile',
      name: 'vjobProfile',
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: '/vjob/profile/edit',
      name: 'vjobEditProfile',
      builder: (context, state) => _buildPlaceholderPage('Edit VJob Profile'),
    ),

    // ==================== VJOB NOTIFICATIONS ROUTE ====================
    GoRoute(
      path: '/vjob/notifications',
      name: 'vjobNotifications',
      builder: (context, state) => _buildPlaceholderPage('VJob Notifications'),
    ),

    // ==================== VJOB ANALYTICS/DASHBOARD ROUTES ====================
    GoRoute(
      path: '/vjob/dashboard',
      name: 'vjobDashboard',
      builder: (context, state) => _buildPlaceholderPage('VJob Dashboard'),
    ),

    GoRoute(
      path: '/vjob/analytics',
      name: 'vjobAnalytics',
      builder: (context, state) => _buildPlaceholderPage('VJob Analytics'),
    ),

    // ==================== VJOB SETTINGS ROUTE ====================
    GoRoute(
      path: '/vjob/settings',
      name: 'vjobSettings',
      builder: (context, state) => _buildPlaceholderPage('VJob Settings'),
    ),

    // ==================== VJOB HELP/SUPPORT ROUTES ====================
    GoRoute(
      path: '/vjob/help',
      name: 'vjobHelp',
      builder: (context, state) => _buildPlaceholderPage('VJob Help'),
    ),

    GoRoute(
      path: '/vjob/support',
      name: 'vjobSupport',
      builder: (context, state) => _buildPlaceholderPage('VJob Support'),
    ),

    // ==================== VJOB FILTERS/PREFERENCES ROUTES ====================
    GoRoute(
      path: '/vjob/filters',
      name: 'vjobFilters',
      builder: (context, state) => _buildPlaceholderPage('Job Filters'),
    ),

    GoRoute(
      path: '/vjob/preferences',
      name: 'vjobPreferences',
      builder: (context, state) => _buildPlaceholderPage('Job Preferences'),
    ),

    // ==================== VJOB RECOMMENDATIONS ROUTE ====================
    GoRoute(
      path: '/vjob/recommendations',
      name: 'vjobRecommendations',
      builder: (context, state) => _buildPlaceholderPage('Job Recommendations'),
    ),

    // ==================== VJOB INTERVIEW RELATED ROUTES ====================
    GoRoute(
      path: '/vjob/interviews',
      name: 'vjobInterviews',
      builder: (context, state) => _buildPlaceholderPage('My Interviews'),
    ),

    GoRoute(
      path: '/vjob/interview/:interviewId',
      name: 'vjobInterviewDetails',
      builder: (context, state) {
        final interviewId = state.pathParameters['interviewId']!;
        return _buildPlaceholderPage('Interview Details: $interviewId');
      },
    ),

    // ==================== VJOB COMPANY PROFILE ROUTES ====================
    GoRoute(
      path: '/vjob/company/profile',
      name: 'vjobCompanyProfile',
      builder: (context, state) => _buildPlaceholderPage('Company Profile'),
    ),

    GoRoute(
      path: '/vjob/company/:companyId',
      name: 'vjobCompanyDetails',
      builder: (context, state) {
        final companyId = state.pathParameters['companyId']!;
        return _buildPlaceholderPage('Company Details: $companyId');
      },
    ),

    // ==================== VJOB SALARY/COMPENSATION ROUTES ====================
    GoRoute(
      path: '/vjob/salary-guide',
      name: 'vjobSalaryGuide',
      builder: (context, state) => _buildPlaceholderPage('Salary Guide'),
    ),

    GoRoute(
      path: '/vjob/compensation/:jobId',
      name: 'vjobCompensation',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return _buildPlaceholderPage('Compensation Details: $jobId');
      },
    ),

    // ==================== VJOB REPORTS/STATISTICS ROUTES ====================
    GoRoute(
      path: '/vjob/reports',
      name: 'vjobReports',
      builder: (context, state) => _buildPlaceholderPage('VJob Reports'),
    ),

    GoRoute(
      path: '/vjob/statistics',
      name: 'vjobStatistics',
      builder: (context, state) => _buildPlaceholderPage('Job Statistics'),
    ),

    // ==================== VJOB SKILLS/CAREER ROUTES ====================
    GoRoute(
      path: '/vjob/skills',
      name: 'vjobSkills',
      builder: (context, state) => _buildPlaceholderPage('Skills Assessment'),
    ),

    GoRoute(
      path: '/vjob/career-path',
      name: 'vjobCareerPath',
      builder: (context, state) => _buildPlaceholderPage('Career Path'),
    ),

    // ==================== VJOB LOCATION ROUTES ====================
    GoRoute(
      path: '/vjob/location/states',
      name: 'vjobStates',
      builder: (context, state) => _buildPlaceholderPage('Select State'),
    ),

    GoRoute(
      path: '/vjob/location/cities/:state',
      name: 'vjobCities',
      builder: (context, state) {
        final stateParam = state.pathParameters['state']!;
        return _buildPlaceholderPage('Select City in $stateParam');
      },
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
  static const String vjobMyPostsPath = '/vjob/my-posts';
  static const String vjobPostDetailPath = '/vjob/post-detail';
  static const String vjobEditPostPath = '/vjob/edit-post';
  static const String vjobPostStatsPath = '/vjob/post-stats';
  static const String vjobProfilePath = '/vjob/profile';

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

  static String buildCompanyJobDetailsRoute(String jobId) {
    return '/vjob/company-job-details/$jobId';
  }

  static String buildJobApplicationRoute(String jobId) {
    return '/vjob/apply/$jobId';
  }

  static String buildCompanyDetailsRoute(String companyId) {
    return '/vjob/company/$companyId';
  }

  static String buildInterviewDetailsRoute(String interviewId) {
    return '/vjob/interview/$interviewId';
  }

  static String buildCompensationRoute(String jobId) {
    return '/vjob/compensation/$jobId';
  }

  static String buildCitiesRoute(String state) {
    return '/vjob/location/cities/$state';
  }

  static String buildEditJobRoute(String jobId) {
    return '${RouteConstants.vjobCreateJob}/edit/$jobId';
  }

  static String buildPostDetailRoute(String postId) {
    return '/vjob/post-detail/$postId';
  }

  static String buildEditPostRoute(String postId) {
    return '/vjob/edit-post/$postId';
  }

  /// Navigation helper methods
  static void navigateToJobDetails(BuildContext context, String jobId) {
    context.push(buildJobDetailsRoute(jobId));
  }

  static void navigateToCreateJob(BuildContext context) {
    context.push(vjobCreateJobPath);
  }

  static void navigateToEditJob(BuildContext context, String jobId) {
    context.push(buildEditJobRoute(jobId));
  }

  static void navigateToMyJobs(BuildContext context) {
    context.push(vjobMyJobsPath);
  }

  static void navigateToCreateCompany(BuildContext context) {
    context.push(vjobCreateCompanyPath);
  }

  static void navigateToMyCompany(BuildContext context) {
    context.push('/vjob/my-company');
  }

  static void navigateToCompanyJobDetails(BuildContext context, String jobId) {
    context.push(buildCompanyJobDetailsRoute(jobId));
  }

  static void navigateToJobApplication(BuildContext context, String jobId) {
    context.push(buildJobApplicationRoute(jobId));
  }

  static void navigateToCompanyDetails(BuildContext context, String companyId) {
    context.push(buildCompanyDetailsRoute(companyId));
  }

  // Post navigation methods
  static void navigateToCreatePost(BuildContext context) {
    context.push(vjobCreatePostPath);
  }

  static void navigateToMyPosts(BuildContext context) {
    context.push(vjobMyPostsPath);
  }

  static void navigateToPostDetail(BuildContext context, String postId) {
    context.push(buildPostDetailRoute(postId));
  }

  static void navigateToEditPost(
    BuildContext context,
    String postId, {
    dynamic post,
  }) {
    context.push(buildEditPostRoute(postId), extra: {'post': post});
  }

  static void navigateToPostStats(BuildContext context) {
    context.push(vjobPostStatsPath);
  }

  // Profile navigation methods
  static void navigateToProfile(BuildContext context) {
    context.push(vjobProfilePath);
  }

  static void navigateToEditProfile(BuildContext context) {
    context.push('/vjob/profile/edit');
  }

  // Search navigation methods
  static void navigateToSearch(
    BuildContext context, {
    String? query,
    String? location,
    String? workStyle,
  }) {
    context.push(
      buildJobSearchRoute(
        query: query,
        location: location,
        workStyle: workStyle,
      ),
    );
  }

  static void navigateToSalaryGuide(BuildContext context) {
    context.push('/vjob/salary-guide');
  }

  static void navigateToSkillsAssessment(BuildContext context) {
    context.push('/vjob/skills');
  }

  static void navigateToCareerPath(BuildContext context) {
    context.push('/vjob/career-path');
  }

  static void navigateToInterviews(BuildContext context) {
    context.push('/vjob/interviews');
  }

  static void navigateToNotifications(BuildContext context) {
    context.push('/vjob/notifications');
  }

  static void navigateToDashboard(BuildContext context) {
    context.push('/vjob/dashboard');
  }

  static void navigateToSettings(BuildContext context) {
    context.push('/vjob/settings');
  }

  static void navigateToHelp(BuildContext context) {
    context.push('/vjob/help');
  }

  static void navigateToSupport(BuildContext context) {
    context.push('/vjob/support');
  }

  static void navigateToFilters(BuildContext context) {
    context.push('/vjob/filters');
  }

  static void navigateToPreferences(BuildContext context) {
    context.push('/vjob/preferences');
  }

  static void navigateToRecommendations(BuildContext context) {
    context.push('/vjob/recommendations');
  }

  static void navigateToReports(BuildContext context) {
    context.push('/vjob/reports');
  }

  static void navigateToStatistics(BuildContext context) {
    context.push('/vjob/statistics');
  }

  /// Route validation helpers
  static bool isVJobRoute(String route) {
    return route.startsWith('/vjob');
  }

  static bool isJobDetailsRoute(String route) {
    return route.startsWith('/vjob/job-details/');
  }

  static bool isCompanyRoute(String route) {
    return route.contains('/vjob/company') ||
        route.contains('/vjob/create-company');
  }

  static bool isMyJobsRoute(String route) {
    return route == '/vjob/my-jobs' ||
        route == '/vjob/applications' ||
        route == '/vjob/saved-jobs';
  }

  static bool isCreateJobRoute(String route) {
    return route.startsWith('/vjob/create-job');
  }

  static bool isPostRoute(String route) {
    return route.contains('/vjob/post') ||
        route.contains('/vjob/create-post') ||
        route.contains('/vjob/my-posts');
  }

  static bool isCreatePostRoute(String route) {
    return route.startsWith('/vjob/create-post');
  }

  static bool isMyPostsRoute(String route) {
    return route == '/vjob/my-posts';
  }

  static bool isProfileRoute(String route) {
    return route.startsWith('/vjob/profile');
  }

  static bool isSearchRoute(String route) {
    return route.startsWith('/vjob/search');
  }

  /// Extract route parameters
  static String? extractJobIdFromRoute(String route) {
    final jobDetailsPattern = RegExp(r'/vjob/job-details/([^/]+)');
    final match = jobDetailsPattern.firstMatch(route);
    return match?.group(1);
  }

  static String? extractCompanyIdFromRoute(String route) {
    final companyPattern = RegExp(r'/vjob/company/([^/]+)');
    final match = companyPattern.firstMatch(route);
    return match?.group(1);
  }

  static String? extractPostIdFromRoute(String route) {
    final postPattern = RegExp(r'/vjob/post-detail/([^/]+)');
    final editPostPattern = RegExp(r'/vjob/edit-post/([^/]+)');

    var match = postPattern.firstMatch(route);
    match ??= editPostPattern.firstMatch(route);

    return match?.group(1);
  }

  static String? extractStateFromRoute(String route) {
    final statePattern = RegExp(r'/vjob/location/cities/([^/]+)');
    final match = statePattern.firstMatch(route);
    return match?.group(1);
  }
}
