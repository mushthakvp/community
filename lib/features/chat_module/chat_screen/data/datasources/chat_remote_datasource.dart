import 'dart:convert';
import 'dart:io';

import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> getChat(String chatId);
  Future<List<MessageModel>> getMessages(String chatId);
  Future<String> uploadMedia(String filePath);
  Future<void> markMessageAsRead(String messageId);
  Future<void> joinGroup(String chatId);
  Future<Map<String, dynamic>> getChatWithMessages(String chatId);
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
      '${ChatApiConstants.enterChat}$chatId',
    );
    final data = jsonDecode(response.body);
    final messagesJson = data['messages'] as List<dynamic>;
    return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getChatWithMessages(String chatId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.enterChat}$chatId',
    );
    final data = jsonDecode(response.body);
    final responseData = data['data'] ?? data;
    final groupDetails = responseData['groupDetails'] as Map<String, dynamic>;
    final messagesJson = responseData['messages'] as List<dynamic>;
    final chat = ChatModel.fromJson(groupDetails);
    final messages = messagesJson
        .map((json) => MessageModel.fromJson(json))
        .toList();
    return {'chat': chat, 'messages': messages};
  }

  @override
  Future<String> uploadMedia(String filePath) async {
    File file = File(filePath);
    String? url = await CloudinaryService.uploadSingleImage(file: file);
    return url ?? "";
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await apiClient.post(
      '${ChatApiConstants.fetchAllMessagesSingleChat}/read',
      body: {'messageId': messageId},
    );
  }

  @override
  Future<void> joinGroup(String chatId) async {
    await apiClient.post('${ChatApiConstants.joinCommunity}$chatId');
  }
}
