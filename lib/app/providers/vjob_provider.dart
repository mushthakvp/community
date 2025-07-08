import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/cloudinary_service.dart';
// Company Job Details
import '../../features/vjob/company_job_details/data/datasources/company_job_local_datasource.dart';
import '../../features/vjob/company_job_details/data/datasources/company_job_remote_datasource.dart';
import '../../features/vjob/company_job_details/data/repositories/company_job_repository_impl.dart';
import '../../features/vjob/company_job_details/domain/repositories/company_job_repository.dart';
import '../../features/vjob/company_job_details/domain/usecases/get_job_candidates_usecase.dart';
import '../../features/vjob/company_job_details/domain/usecases/mark_job_as_closed_usecase.dart';
import '../../features/vjob/company_job_details/domain/usecases/reapply_job_usecase.dart'
    as company_job_reapply;
import '../../features/vjob/company_job_details/presentation/providers/company_job_provider.dart';
// Create Company
import '../../features/vjob/create_company/data/datasources/create_company_local_datasource.dart';
import '../../features/vjob/create_company/data/datasources/create_company_remote_datasource.dart';
import '../../features/vjob/create_company/data/repositories/create_company_repository_impl.dart';
import '../../features/vjob/create_company/domain/repositories/create_company_repository.dart';
import '../../features/vjob/create_company/domain/usecases/create_company_usecase.dart';
import '../../features/vjob/create_company/domain/usecases/update_company_usecase.dart';
import '../../features/vjob/create_company/domain/usecases/upload_image_usecase.dart';
import '../../features/vjob/create_company/presentation/providers/create_company_provider.dart';
// Create Job
import '../../features/vjob/create_job/data/datasources/create_job_local_datasource.dart';
import '../../features/vjob/create_job/data/datasources/create_job_remote_datasource.dart';
import '../../features/vjob/create_job/data/repositories/create_job_repository_impl.dart';
import '../../features/vjob/create_job/domain/repositories/create_job_repository.dart';
import '../../features/vjob/create_job/domain/usecases/create_job_title_usecase.dart';
import '../../features/vjob/create_job/domain/usecases/create_job_usecase.dart';
import '../../features/vjob/create_job/domain/usecases/get_job_titles_usecase.dart';
import '../../features/vjob/create_job/domain/usecases/update_job_usecase.dart';
import '../../features/vjob/create_job/presentation/providers/create_job_provider.dart';
// Create Post
import '../../features/vjob/create_post/data/datasources/create_post_local_datasource.dart';
import '../../features/vjob/create_post/data/datasources/create_post_remote_datasource.dart';
import '../../features/vjob/create_post/data/repositories/create_post_repository_impl.dart';
import '../../features/vjob/create_post/domain/repositories/create_post_repository.dart';
import '../../features/vjob/create_post/domain/usecases/create_post_usecase.dart';
import '../../features/vjob/create_post/domain/usecases/delete_post_usecase.dart';
import '../../features/vjob/create_post/domain/usecases/update_post_usecase.dart';
import '../../features/vjob/create_post/domain/usecases/upload_image_usecase.dart'
    as create_post_upload;
import '../../features/vjob/create_post/presentation/providers/create_post_provider.dart';
// VJob Home
import '../../features/vjob/home/data/datasources/vjob_home_local_datasource.dart';
import '../../features/vjob/home/data/datasources/vjob_home_remote_datasource.dart';
import '../../features/vjob/home/data/repositories/vjob_home_repository_impl.dart';
import '../../features/vjob/home/domain/repositories/vjob_home_repository.dart';
import '../../features/vjob/home/domain/usecases/get_jobs_usecase.dart';
import '../../features/vjob/home/domain/usecases/get_posts_usecase.dart';
import '../../features/vjob/home/domain/usecases/like_post_usecase.dart';
import '../../features/vjob/home/domain/usecases/save_job_usecase.dart';
import '../../features/vjob/home/presentation/providers/jobs_provider.dart';
import '../../features/vjob/home/presentation/providers/posts_provider.dart';
// Job Details
import '../../features/vjob/job_details/data/datasources/job_details_local_datasource.dart';
import '../../features/vjob/job_details/data/datasources/job_details_remote_datasource.dart';
import '../../features/vjob/job_details/data/repositories/job_details_repository_impl.dart';
import '../../features/vjob/job_details/domain/repositories/job_details_repository.dart';
import '../../features/vjob/job_details/domain/usecases/apply_job_usecase.dart';
import '../../features/vjob/job_details/domain/usecases/get_job_details_usecase.dart';
import '../../features/vjob/job_details/domain/usecases/save_job_usecase.dart'
    as job_details_save;
import '../../features/vjob/job_details/presentation/providers/job_details_provider.dart';
// My Company
import '../../features/vjob/my_company/data/datasources/my_company_local_datasource.dart';
import '../../features/vjob/my_company/data/datasources/my_company_remote_datasource.dart';
import '../../features/vjob/my_company/data/repositories/my_company_repository_impl.dart';
import '../../features/vjob/my_company/domain/repositories/my_company_repository.dart';
import '../../features/vjob/my_company/domain/usecases/get_company_usecase.dart';
import '../../features/vjob/my_company/domain/usecases/get_created_jobs_usecase.dart';
import '../../features/vjob/my_company/domain/usecases/mark_job_closed_usecase.dart';
import '../../features/vjob/my_company/domain/usecases/reapply_job_usecase.dart';
import '../../features/vjob/my_company/presentation/providers/my_company_provider.dart';
// My Jobs
import '../../features/vjob/my_jobs/data/datasources/my_jobs_local_datasource.dart';
import '../../features/vjob/my_jobs/data/datasources/my_jobs_remote_datasource.dart';
import '../../features/vjob/my_jobs/data/repositories/my_jobs_repository_impl.dart';
import '../../features/vjob/my_jobs/domain/repositories/my_jobs_repository.dart';
import '../../features/vjob/my_jobs/domain/usecases/get_my_jobs_usecase.dart';
import '../../features/vjob/my_jobs/domain/usecases/update_job_status_usecase.dart';
import '../../features/vjob/my_jobs/presentation/providers/my_jobs_provider.dart';
// My Post View
import '../../features/vjob/mypost_view/data/datasources/my_post_local_datasource.dart';
import '../../features/vjob/mypost_view/data/datasources/my_post_remote_datasource.dart';
import '../../features/vjob/mypost_view/data/repositories/my_post_repository_impl.dart';
import '../../features/vjob/mypost_view/domain/repositories/my_post_repository.dart';
import '../../features/vjob/mypost_view/domain/usecases/delete_post_usecase.dart'
    as my_post_delete;
import '../../features/vjob/mypost_view/domain/usecases/get_my_posts_usecase.dart';
import '../../features/vjob/mypost_view/domain/usecases/get_post_by_id_usecase.dart';
import '../../features/vjob/mypost_view/domain/usecases/get_post_stats_usecase.dart';
import '../../features/vjob/mypost_view/domain/usecases/like_post_usecase.dart'
    as my_post_like;
import '../../features/vjob/mypost_view/domain/usecases/search_my_posts_usecase.dart';
import '../../features/vjob/mypost_view/presentation/providers/my_post_provider.dart';

/// VJob feature providers for job portal functionality
class VJobProviders {
  static List<SingleChildWidget> get providers => [
    // ==================== VJOB HOME DATA SOURCES ====================
    Provider<VJobHomeRemoteDataSource>(
      create: (context) =>
          VJobHomeRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<VJobHomeLocalDataSource>(
      create: (context) => VJobHomeLocalDataSourceImpl(),
    ),

    // ==================== VJOB HOME REPOSITORY ====================
    Provider<VJobHomeRepository>(
      create: (context) => VJobHomeRepositoryImpl(
        remoteDataSource: context.read<VJobHomeRemoteDataSource>(),
        localDataSource: context.read<VJobHomeLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== VJOB HOME USE CASES ====================
    Provider<GetJobsUseCase>(
      create: (context) => GetJobsUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<GetPostsUseCase>(
      create: (context) => GetPostsUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<SaveJobUseCase>(
      create: (context) => SaveJobUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<LikePostUseCase>(
      create: (context) => LikePostUseCase(context.read<VJobHomeRepository>()),
    ),

    // ==================== VJOB HOME PROVIDERS ====================
    ChangeNotifierProvider<JobsProvider>(
      create: (context) => JobsProvider(
        getJobsUseCase: context.read<GetJobsUseCase>(),
        saveJobUseCase: context.read<SaveJobUseCase>(),
      ),
    ),
    ChangeNotifierProvider<PostsProvider>(
      create: (context) => PostsProvider(
        getPostsUseCase: context.read<GetPostsUseCase>(),
        likePostUseCase: context.read<LikePostUseCase>(),
      ),
    ),

    // ==================== JOB DETAILS DATA SOURCES ====================
    Provider<JobDetailsRemoteDataSource>(
      create: (context) =>
          JobDetailsRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<JobDetailsLocalDataSource>(
      create: (context) => JobDetailsLocalDataSourceImpl(),
    ),

    // ==================== JOB DETAILS REPOSITORY ====================
    Provider<JobDetailsRepository>(
      create: (context) => JobDetailsRepositoryImpl(
        remoteDataSource: context.read<JobDetailsRemoteDataSource>(),
        localDataSource: context.read<JobDetailsLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== JOB DETAILS USE CASES ====================
    Provider<GetJobDetailsUseCase>(
      create: (context) =>
          GetJobDetailsUseCase(context.read<JobDetailsRepository>()),
    ),
    Provider<ApplyJobUseCase>(
      create: (context) =>
          ApplyJobUseCase(context.read<JobDetailsRepository>()),
    ),
    Provider<job_details_save.SaveJobUseCase>(
      create: (context) =>
          job_details_save.SaveJobUseCase(context.read<JobDetailsRepository>()),
    ),

    // ==================== JOB DETAILS PROVIDER ====================
    ChangeNotifierProvider<JobDetailsProvider>(
      create: (context) => JobDetailsProvider(
        getJobDetailsUseCase: context.read<GetJobDetailsUseCase>(),
        applyJobUseCase: context.read<ApplyJobUseCase>(),
        saveJobUseCase: context.read<job_details_save.SaveJobUseCase>(),
        fileUploadService: CloudinaryService(),
      ),
    ),

    // ==================== CREATE JOB DATA SOURCES ====================
    Provider<CreateJobRemoteDataSource>(
      create: (context) =>
          CreateJobRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<CreateJobLocalDataSource>(
      create: (context) => CreateJobLocalDataSourceImpl(),
    ),

    // ==================== CREATE JOB REPOSITORY ====================
    Provider<CreateJobRepository>(
      create: (context) => CreateJobRepositoryImpl(
        remoteDataSource: context.read<CreateJobRemoteDataSource>(),
        localDataSource: context.read<CreateJobLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== CREATE JOB USE CASES ====================
    Provider<GetJobTitlesUseCase>(
      create: (context) =>
          GetJobTitlesUseCase(context.read<CreateJobRepository>()),
    ),
    Provider<CreateJobTitleUseCase>(
      create: (context) =>
          CreateJobTitleUseCase(context.read<CreateJobRepository>()),
    ),
    Provider<CreateJobUseCase>(
      create: (context) =>
          CreateJobUseCase(context.read<CreateJobRepository>()),
    ),
    Provider<UpdateJobUseCase>(
      create: (context) =>
          UpdateJobUseCase(context.read<CreateJobRepository>()),
    ),

    // ==================== CREATE JOB PROVIDER ====================
    ChangeNotifierProvider<CreateJobProvider>(
      create: (context) => CreateJobProvider(
        getJobTitlesUseCase: context.read<GetJobTitlesUseCase>(),
        createJobTitleUseCase: context.read<CreateJobTitleUseCase>(),
        createJobUseCase: context.read<CreateJobUseCase>(),
        updateJobUseCase: context.read<UpdateJobUseCase>(),
      ),
    ),

    // ==================== CREATE COMPANY DATA SOURCES ====================
    Provider<CreateCompanyRemoteDataSource>(
      create: (context) => CreateCompanyRemoteDataSourceImpl(
        apiClient: context.read<ApiClient>(),
      ),
    ),
    Provider<CreateCompanyLocalDataSource>(
      create: (context) => CreateCompanyLocalDataSourceImpl(),
    ),

    // ==================== CREATE COMPANY REPOSITORY ====================
    Provider<CreateCompanyRepository>(
      create: (context) => CreateCompanyRepositoryImpl(
        remoteDataSource: context.read<CreateCompanyRemoteDataSource>(),
        localDataSource: context.read<CreateCompanyLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== CREATE COMPANY USE CASES ====================
    Provider<CreateCompanyUseCase>(
      create: (context) =>
          CreateCompanyUseCase(context.read<CreateCompanyRepository>()),
    ),
    Provider<UpdateCompanyUseCase>(
      create: (context) =>
          UpdateCompanyUseCase(context.read<CreateCompanyRepository>()),
    ),
    Provider<UploadImageUseCase>(
      create: (context) =>
          UploadImageUseCase(context.read<CreateCompanyRepository>()),
    ),

    // ==================== CREATE COMPANY PROVIDER ====================
    ChangeNotifierProvider<CreateCompanyProvider>(
      create: (context) => CreateCompanyProvider(
        createCompanyUseCase: context.read<CreateCompanyUseCase>(),
        updateCompanyUseCase: context.read<UpdateCompanyUseCase>(),
        uploadImageUseCase: context.read<UploadImageUseCase>(),
      ),
    ),

    // ==================== MY COMPANY DATA SOURCES ====================
    Provider<MyCompanyRemoteDataSource>(
      create: (context) =>
          MyCompanyRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<MyCompanyLocalDataSource>(
      create: (context) => MyCompanyLocalDataSourceImpl(),
    ),

    // ==================== MY COMPANY REPOSITORY ====================
    Provider<MyCompanyRepository>(
      create: (context) => MyCompanyRepositoryImpl(
        remoteDataSource: context.read<MyCompanyRemoteDataSource>(),
        localDataSource: context.read<MyCompanyLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== MY COMPANY USE CASES ====================
    Provider<GetCompanyUseCase>(
      create: (context) =>
          GetCompanyUseCase(context.read<MyCompanyRepository>()),
    ),
    Provider<GetCreatedJobsUseCase>(
      create: (context) =>
          GetCreatedJobsUseCase(context.read<MyCompanyRepository>()),
    ),
    Provider<MarkJobClosedUseCase>(
      create: (context) =>
          MarkJobClosedUseCase(context.read<MyCompanyRepository>()),
    ),
    Provider<ReapplyJobUseCase>(
      create: (context) =>
          ReapplyJobUseCase(context.read<MyCompanyRepository>()),
    ),

    // ==================== MY COMPANY PROVIDER ====================
    ChangeNotifierProvider<MyCompanyProvider>(
      create: (context) => MyCompanyProvider(
        getCompanyUseCase: context.read<GetCompanyUseCase>(),
        getCreatedJobsUseCase: context.read<GetCreatedJobsUseCase>(),
        reapplyJobUseCase: context.read<ReapplyJobUseCase>(),
        markJobClosedUseCase: context.read<MarkJobClosedUseCase>(),
      ),
    ),

    // ==================== COMPANY JOB DETAILS DATA SOURCES ====================
    Provider<CompanyJobRemoteDataSource>(
      create: (context) =>
          CompanyJobRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<CompanyJobLocalDataSource>(
      create: (context) => CompanyJobLocalDataSourceImpl(),
    ),

    // ==================== COMPANY JOB DETAILS REPOSITORY ====================
    Provider<CompanyJobRepository>(
      create: (context) => CompanyJobRepositoryImpl(
        remoteDataSource: context.read<CompanyJobRemoteDataSource>(),
        localDataSource: context.read<CompanyJobLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== COMPANY JOB DETAILS USE CASES ====================
    Provider<GetJobCandidatesUseCase>(
      create: (context) =>
          GetJobCandidatesUseCase(context.read<CompanyJobRepository>()),
    ),
    Provider<MarkJobAsClosedUseCase>(
      create: (context) =>
          MarkJobAsClosedUseCase(context.read<CompanyJobRepository>()),
    ),
    Provider<company_job_reapply.ReapplyJobUseCase>(
      create: (context) => company_job_reapply.ReapplyJobUseCase(
        context.read<CompanyJobRepository>(),
      ),
    ),

    // ==================== COMPANY JOB DETAILS PROVIDER ====================
    ChangeNotifierProvider<CompanyJobProvider>(
      create: (context) => CompanyJobProvider(
        getJobCandidatesUseCase: context.read<GetJobCandidatesUseCase>(),
        markJobAsClosedUseCase: context.read<MarkJobAsClosedUseCase>(),
        reapplyJobUseCase: context
            .read<company_job_reapply.ReapplyJobUseCase>(),
      ),
    ),

    // ==================== MY JOBS DATA SOURCES ====================
    Provider<MyJobsRemoteDataSource>(
      create: (context) =>
          MyJobsRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<MyJobsLocalDataSource>(
      create: (context) => MyJobsLocalDataSourceImpl(),
    ),

    // ==================== MY JOBS REPOSITORY ====================
    Provider<MyJobsRepository>(
      create: (context) => MyJobsRepositoryImpl(
        remoteDataSource: context.read<MyJobsRemoteDataSource>(),
        localDataSource: context.read<MyJobsLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== MY JOBS USE CASES ====================
    Provider<GetMyJobsUseCase>(
      create: (context) => GetMyJobsUseCase(context.read<MyJobsRepository>()),
    ),
    Provider<UpdateJobStatusUseCase>(
      create: (context) =>
          UpdateJobStatusUseCase(context.read<MyJobsRepository>()),
    ),

    // ==================== MY JOBS PROVIDER ====================
    ChangeNotifierProvider<MyJobsProvider>(
      create: (context) => MyJobsProvider(
        getMyJobsUseCase: context.read<GetMyJobsUseCase>(),
        updateJobStatusUseCase: context.read<UpdateJobStatusUseCase>(),
      ),
    ),

    // ==================== CREATE POST DATA SOURCES ====================
    Provider<CreatePostRemoteDataSource>(
      create: (context) =>
          CreatePostRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<CreatePostLocalDataSource>(
      create: (context) => CreatePostLocalDataSourceImpl(),
    ),

    // ==================== CREATE POST REPOSITORY ====================
    Provider<CreatePostRepository>(
      create: (context) => CreatePostRepositoryImpl(
        remoteDataSource: context.read<CreatePostRemoteDataSource>(),
        localDataSource: context.read<CreatePostLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== CREATE POST USE CASES ====================
    Provider<CreatePostUseCase>(
      create: (context) =>
          CreatePostUseCase(context.read<CreatePostRepository>()),
    ),
    Provider<UpdatePostUseCase>(
      create: (context) =>
          UpdatePostUseCase(context.read<CreatePostRepository>()),
    ),
    Provider<DeletePostUseCase>(
      create: (context) =>
          DeletePostUseCase(context.read<CreatePostRepository>()),
    ),
    Provider<create_post_upload.UploadImageUseCase>(
      create: (context) => create_post_upload.UploadImageUseCase(
        context.read<CreatePostRepository>(),
      ),
    ),

    // ==================== CREATE POST PROVIDER ====================
    ChangeNotifierProvider<CreatePostProvider>(
      create: (context) => CreatePostProvider(
        createPostUseCase: context.read<CreatePostUseCase>(),
        updatePostUseCase: context.read<UpdatePostUseCase>(),
        uploadImageUseCase: context
            .read<create_post_upload.UploadImageUseCase>(),
        deletePostUseCase: context.read<DeletePostUseCase>(),
      ),
    ),

    // ==================== MY POST VIEW DATA SOURCES ====================
    Provider<MyPostRemoteDataSource>(
      create: (context) =>
          MyPostRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<MyPostLocalDataSource>(
      create: (context) => MyPostLocalDataSourceImpl(),
    ),

    // ==================== MY POST VIEW REPOSITORY ====================
    Provider<MyPostRepository>(
      create: (context) => MyPostRepositoryImpl(
        remoteDataSource: context.read<MyPostRemoteDataSource>(),
        localDataSource: context.read<MyPostLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // ==================== MY POST VIEW USE CASES ====================
    Provider<GetMyPostsUseCase>(
      create: (context) => GetMyPostsUseCase(context.read<MyPostRepository>()),
    ),
    Provider<GetPostByIdUseCase>(
      create: (context) => GetPostByIdUseCase(context.read<MyPostRepository>()),
    ),
    Provider<my_post_like.LikeMyPostUseCase>(
      create: (context) =>
          my_post_like.LikeMyPostUseCase(context.read<MyPostRepository>()),
    ),
    Provider<my_post_delete.DeleteMyPostUseCase>(
      create: (context) =>
          my_post_delete.DeleteMyPostUseCase(context.read<MyPostRepository>()),
    ),
    Provider<GetPostStatsUseCase>(
      create: (context) =>
          GetPostStatsUseCase(context.read<MyPostRepository>()),
    ),
    Provider<SearchMyPostsUseCase>(
      create: (context) =>
          SearchMyPostsUseCase(context.read<MyPostRepository>()),
    ),

    // ==================== MY POST VIEW PROVIDER ====================
    ChangeNotifierProvider<MyPostProvider>(
      create: (context) => MyPostProvider(
        getMyPostsUseCase: context.read<GetMyPostsUseCase>(),
        getPostByIdUseCase: context.read<GetPostByIdUseCase>(),
        likePostUseCase: context.read<my_post_like.LikeMyPostUseCase>(),
        deletePostUseCase: context.read<my_post_delete.DeleteMyPostUseCase>(),
        getPostStatsUseCase: context.read<GetPostStatsUseCase>(),
        searchMyPostsUseCase: context.read<SearchMyPostsUseCase>(),
      ),
    ),
  ];
}
