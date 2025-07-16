import 'api_client.dart';

class ApiClientWrapper {
  final ApiClient mainClient;
  final ApiClient chatClient;

  ApiClientWrapper({required this.mainClient, required this.chatClient});
}
