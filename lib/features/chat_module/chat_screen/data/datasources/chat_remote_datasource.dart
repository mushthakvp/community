import 'dart:convert';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> getChat(String chatId);
  Future<List<MessageModel>> getMessages(String chatId);
  Future<String> uploadMedia(String filePath);
  Future<void> markMessageAsRead(String messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChatModel> getChat(String chatId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.getSingleChat}?friendId=$chatId',
    );
    final data = jsonDecode(response.body);
    return ChatModel.fromJson(data['chat']);
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.getSingleChat}?friendId=$chatId',
    );
    final data = jsonDecode(response.body);
    final messagesJson = data['messages'] as List<dynamic>;
    return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<String> uploadMedia(String filePath) async {
    // Implementation for media upload
    // This would use your existing upload logic
    throw UnimplementedError('Upload media implementation needed');
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await apiClient.post(
      '${ChatApiConstants.fetchAllMessagesSingleChat}/read',
      body: {'messageId': messageId},
    );
  }
}
