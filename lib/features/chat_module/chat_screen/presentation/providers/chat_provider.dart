import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/fetch_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/upload_media.dart';

class ChatProvider extends ChangeNotifier {
  final FetchMessages fetchMessages;
  final FetchChatWithMessages fetchChatWithMessages;
  final SendMessage sendMessage;
  final UploadMedia uploadMedia;
  final ChatRepository chatRepository;

  ChatProvider({
    required this.fetchMessages,
    required this.fetchChatWithMessages,
    required this.sendMessage,
    required this.uploadMedia,
    required this.chatRepository,
  });

  // State
  List<MessageEntity> _messages = [];
  ChatEntity? _currentChat;
  bool _isLoading = false;
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isSending = false;
  String? _error;

  // Voice recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  // Stream subscriptions
  StreamSubscription<MessageEntity>? _messageSubscription;

  // Getters
  List<MessageEntity> get messages => _messages;
  ChatEntity? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  bool get isRecording => _isRecording;
  bool get isUploading => _isUploading;
  bool get isSending => _isSending;
  String? get error => _error;
  int get recordingDuration => _recordingDuration;
  bool get hasText => messageController.text.trim().isNotEmpty;

  // Add getter for bot status
  bool get isBotChat => _currentChat?.isBot ?? false;

  // Add getters for new chat states
  bool get canSendMessages =>
      _currentChat?.isCreator == true || _currentChat?.isUserInGroup == true;
  bool get isRequestSent =>
      _currentChat?.isUserRequested == true &&
      _currentChat?.isUserInGroup == false;
  bool get needsJoinRequest =>
      !canSendMessages &&
      !isRequestSent &&
      (_currentChat?.isBot == true || _currentChat?.isGroup == true);

  // Initialize chat - Optimized to get both chat and messages in one call
  Future<void> initializeChat(String chatId) async {
    _setLoading(true);
    _clearError();
    try {
      // Use the combined method to get both chat and messages efficiently
      final result = await fetchChatWithMessages(
        FetchChatWithMessagesParams(chatId: chatId),
      );

      result.fold((failure) => _setError(failure.message), (data) {
        _currentChat = data['chat'] as ChatEntity;
        _messages = data['messages'] as List<MessageEntity>;
        _scrollToBottom();
        notifyListeners(); // Notify listeners so UI can update with bot status
      });

      // Set up socket listener for new messages only if user can receive messages
      if (_currentChat?.isUserInGroup == true ||
          _currentChat?.isCreator == true) {
        _messageSubscription?.cancel();
        _messageSubscription = chatRepository
            .listenToNewMessages(chatId)
            .listen(
              _onNewMessage,
              onError: (error) => _setError(error.toString()),
            );
      }
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  // Send text message
  Future<void> sendTextMessage(String chatId) async {
    final content = messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    // Check if user can send messages
    if (!canSendMessages) {
      _setError('You cannot send messages to this chat');
      return;
    }

    _setSending(true);
    messageController.clear();
    try {
      final result = await sendMessage(
        SendMessageParams(chatId: chatId, content: content),
      );
      result.fold((failure) => _setError(failure.message), (message) {
        _addOptimisticMessage(message);
      });
    } catch (e) {
      _setError(e.toString());
      messageController.text = content;
    }
    _setSending(false);
  }

  // Send media message
  Future<void> sendMediaMessage(
    String chatId,
    File file,
    String mediaType,
  ) async {
    if (_isUploading) return;

    // Check if user can send messages
    if (!canSendMessages) {
      _setError('You cannot send media to this chat');
      return;
    }

    _setUploading(true);
    try {
      final uploadResult = await uploadMedia(
        UploadMediaParams(filePath: file.path),
      );
      await uploadResult.fold((failure) async => _setError(failure.message), (
        mediaUrl,
      ) async {
        final result = await sendMessage(
          SendMessageParams(
            chatId: chatId,
            content: '',
            mediaUrl: mediaUrl,
            mediaType: mediaType,
          ),
        );
        result.fold((failure) => _setError(failure.message), (message) {
          _addOptimisticMessage(message);
        });
      });
    } catch (e) {
      _setError(e.toString());
    }
    _setUploading(false);
  }

  // Join group/bot functionality
  Future<void> joinGroupOrBot(String chatId) async {
    if (_isLoading) return;

    _setLoading(true);
    try {
      final result = await chatRepository.joinGroup(chatId);
      result.fold((failure) => _setError(failure.message), (_) {
        // Refresh chat data after successful join
        initializeChat(chatId);
        _setError(null); // Clear any previous errors
      });
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  // Image picker
  Future<void> pickImage(String chatId, {bool fromCamera = false}) async {
    if (!canSendMessages) {
      _setError('You cannot send images to this chat');
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        final extension = path.extension(image.path).toLowerCase();
        await sendMediaMessage(
          chatId,
          file,
          extension.substring(1),
        ); // Remove the dot
      }
    } catch (e) {
      _setError('Failed to pick image: $e');
    }
  }

  // File picker
  Future<void> pickFile(String chatId) async {
    if (!canSendMessages) {
      _setError('You cannot send files to this chat');
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final extension = result.files.single.extension ?? 'file';
        await sendMediaMessage(chatId, file, extension);
      }
    } catch (e) {
      _setError('Failed to pick file: $e');
    }
  }

  // Voice recording methods
  Future<void> startRecording() async {
    if (!canSendMessages) {
      _setError('You cannot send voice messages to this chat');
      return;
    }

    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        _setError('Microphone permission is required for voice messages');
        return;
      }
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _recordingPath = path.join(directory.path, fileName);
        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );
        await _audioRecorder.start(config, path: _recordingPath!);
        _isRecording = true;
        _recordingDuration = 0;
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _recordingDuration++;
          notifyListeners();
        });
        notifyListeners();
      } else {
        _setError('Microphone permission denied');
      }
    } catch (e) {
      _setError('Failed to start recording: $e');
    }
  }

  Future<void> stopRecording(String chatId) async {
    if (!_isRecording) return;
    try {
      await _audioRecorder.stop();
      _stopRecordingTimer();
      if (_recordingPath != null && _recordingDuration > 0) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await sendMediaMessage(chatId, file, 'm4a');
        }
      }
      _resetRecording();
    } catch (e) {
      _setError('Failed to stop recording: $e');
      _resetRecording();
    }
  }

  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    try {
      await _audioRecorder.stop();
      _stopRecordingTimer();
      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      _resetRecording();
    } catch (e) {
      _setError('Failed to cancel recording: $e');
      _resetRecording();
    }
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      _messages.removeWhere((message) => message.id == messageId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete message: $e');
      if (_currentChat != null) {
        initializeChat(_currentChat!.id);
      }
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead() async {
    try {
      final unreadMessages = _messages
          .where((message) => !message.isCurrentUser && message.id.isNotEmpty)
          .toList();
      for (final message in unreadMessages) {
        await chatRepository.markMessageAsRead(message.id);
      }
    } catch (e) {
      debugPrint('Failed to mark messages as read: $e');
    }
  }

  // Retry failed message
  Future<void> retryMessage(String chatId, MessageEntity message) async {
    try {
      if (message.mediaUrl != null && message.mediaUrl!.isNotEmpty) {
        _setError('Cannot retry media messages');
      } else {
        final result = await sendMessage(
          SendMessageParams(chatId: chatId, content: message.content),
        );
        result.fold((failure) => _setError(failure.message), (newMessage) {
          _messages.removeWhere((m) => m.id == message.id);
          _addOptimisticMessage(newMessage);
        });
      }
    } catch (e) {
      _setError('Failed to retry message: $e');
    }
  }

  Future<void> clearChatHistory() async {
    try {
      _messages.clear();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear chat history: $e');
    }
  }

  List<MessageEntity> searchMessages(String query) {
    if (query.trim().isEmpty) return _messages;
    final lowercaseQuery = query.toLowerCase();
    return _messages
        .where(
          (message) =>
              message.content.toLowerCase().contains(lowercaseQuery) ||
              message.senderName.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  MessageEntity? getMessageById(String messageId) {
    try {
      return _messages.firstWhere((message) => message.id == messageId);
    } catch (e) {
      return null;
    }
  }

  // Private methods
  void _onNewMessage(MessageEntity message) {
    final existingIndex = _messages.indexWhere((m) => m.id == message.id);
    if (existingIndex != -1) {
      _messages[existingIndex] = message;
    } else {
      _messages.add(message);
    }
    _scrollToBottom();
    notifyListeners();
    if (!message.isCurrentUser) {
      markMessagesAsRead();
    }
  }

  void _addOptimisticMessage(MessageEntity message) {
    _messages.add(message);
    _scrollToBottom();
    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  void _resetRecording() {
    _isRecording = false;
    _recordingDuration = 0;
    _recordingPath = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  void _setSending(bool sending) {
    _isSending = sending;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
  }

  void scrollToBottom() {
    _scrollToBottom();
  }

  Future<void> refreshChat(String chatId) async {
    await initializeChat(chatId);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
