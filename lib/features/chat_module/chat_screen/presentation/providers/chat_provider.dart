import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../shared/cache/chat_cache_data.dart';
import '../../data/datasources/socket_datasource.dart';
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
  final SocketDataSource socketDataSource;

  ChatProvider({
    required this.fetchMessages,
    required this.fetchChatWithMessages,
    required this.sendMessage,
    required this.uploadMedia,
    required this.chatRepository,
    required this.socketDataSource,
  }) {
    _initializeCache();
  }

  final Map<String, ChatCacheData> _memoryCache = {};

  // Current chat state
  String? _currentChatId;
  List<MessageEntity> _messages = [];
  ChatEntity? _currentChat;
  bool _isLoading = false;
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isSending = false;
  bool _isConnecting = false;
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

  // Track connected room
  String? _connectedChatId;

  // Initialize cache
  Future<void> _initializeCache() async {
    try {
      // Initialize persistent cache manager
      // await ChatCacheManager.initialize();
      debugPrint('Chat cache initialized');
    } catch (e) {
      debugPrint('Failed to initialize cache: $e');
    }
  }

  // Getters
  List<MessageEntity> get messages => _messages;
  ChatEntity? get currentChat => _currentChat;
  String? get currentChatId => _currentChatId;
  bool get isLoading => _isLoading;
  bool get isRecording => _isRecording;
  bool get isUploading => _isUploading;
  bool get isSending => _isSending;
  bool get isConnecting => _isConnecting;
  String? get error => _error;
  int get recordingDuration => _recordingDuration;
  bool get hasText => messageController.text.trim().isNotEmpty;
  bool get isBotChat => _currentChat?.isBot ?? false;
  bool get canSendMessages =>
      _currentChat?.isCreator == true || _currentChat?.isUserInGroup == true;
  bool get isRequestSent =>
      _currentChat?.isUserRequested == true &&
      _currentChat?.isUserInGroup == false;
  bool get needsJoinRequest =>
      !canSendMessages &&
      !isRequestSent &&
      (_currentChat?.isBot == true || _currentChat?.isGroup == true);
  bool get isSocketConnected => socketDataSource is SocketDataSourceImpl
      ? (socketDataSource as SocketDataSourceImpl).isConnected
      : false;

  // Clear current chat state completely
  void _clearCurrentChat() {
    debugPrint('Clearing current chat state for: $_currentChatId');

    // Cancel message subscription
    _messageSubscription?.cancel();
    _messageSubscription = null;

    // Leave current room if connected
    if (_connectedChatId != null) {
      socketDataSource.leaveRoom(_connectedChatId!).catchError((e) {
        debugPrint('Error leaving room: $e');
      });
      _connectedChatId = null;
    }

    // Clear state immediately
    final previousChatId = _currentChatId;
    _currentChatId = null;
    _messages.clear();
    _currentChat = null;
    _clearError();

    // Clear text input
    messageController.clear();

    debugPrint('Cleared chat state for: $previousChatId');
    notifyListeners();
  }

  // Initialize chat with enhanced caching
  Future<void> initializeChat(String chatId) async {
    debugPrint('=== Initializing chat: $chatId ===');

    // If switching to a different chat, clear previous state first
    if (_currentChatId != null && _currentChatId != chatId) {
      debugPrint('Switching from $_currentChatId to $chatId');
      _clearCurrentChat();

      // Add a small delay to ensure clean state transition
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _currentChatId = chatId;
    _setLoading(true);
    _clearError();

    // Declare cachedData outside the try block so it's accessible throughout the method
    ChatCacheData? cachedData;

    try {
      // Load from cache first for instant display
      // Try persistent cache first
      try {
        // cachedData = await ChatCacheManager.getCachedChat(chatId);
        cachedData = _memoryCache[chatId];
      } catch (e) {
        debugPrint('Error loading from persistent cache: $e');
        // Fallback to memory cache
        cachedData = _memoryCache[chatId];
      }

      if (cachedData != null && !cachedData.isExpired()) {
        debugPrint('Loading chat from cache: $chatId');
        _currentChat = cachedData.chat;
        _messages = List.from(cachedData.messages);
        notifyListeners(); // Show cached data immediately
        _scrollToBottom();
      }
      // Ensure socket connection
      await _ensureSocketConnection();
      // Join the room
      await _joinSocketRoom(chatId);

      // Start listening to messages
      _setupMessageListener(chatId);

      // Fetch fresh data from server
      debugPrint('Fetching fresh data for chat: $chatId');
      final result = await fetchChatWithMessages(
        FetchChatWithMessagesParams(chatId: chatId),
      );

      result.fold(
        (failure) {
          debugPrint('Failed to fetch chat data: ${failure.message}');
          // If we have cached data, don't show error
          if (cachedData == null) {
            _setError(failure.message);
          }
        },
        (data) {
          debugPrint('Successfully fetched fresh chat data');
          _currentChat = data['chat'] as ChatEntity;
          _messages = data['messages'] as List<MessageEntity>;

          // Update both caches with fresh data
          _updateCache(chatId, _currentChat!, _messages);

          _scrollToBottom();
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Initialize chat error: $e');
      // If we have cached data, don't show error
      if (cachedData == null) {
        _setError(e.toString());
      }
    }
    _setLoading(false);
    debugPrint('=== Chat initialization complete: $chatId ===');
  }

  // Setup message listener
  void _setupMessageListener(String chatId) {
    // Cancel any existing subscription
    _messageSubscription?.cancel();

    debugPrint('Setting up message listener for chat: $chatId');

    _messageSubscription = chatRepository
        .listenToNewMessages(chatId)
        .listen(
          (message) {
            // Only process messages for the current chat
            if (_currentChatId == chatId) {
              debugPrint(
                'Received new message for current chat: ${message.content}',
              );
              _onNewMessage(message);
            } else {
              debugPrint(
                'Ignoring message for different chat: ${message.chatId}',
              );
            }
          },
          onError: (error) {
            debugPrint('Message listener error: $error');
            if (_currentChatId == chatId) {
              _setError('Connection error: $error');
            }
          },
          onDone: () {
            debugPrint('Message stream closed for chat: $chatId');
          },
        );
  }

  // Ensure socket connection
  Future<void> _ensureSocketConnection() async {
    if (!isSocketConnected) {
      _setConnecting(true);
      try {
        await socketDataSource.connect();
        debugPrint('Socket connected successfully');
      } catch (e) {
        debugPrint('Failed to connect socket: $e');
        _setError('Failed to connect to chat server. Please try again.');
        rethrow;
      } finally {
        _setConnecting(false);
      }
    }
  }

  // Join socket room
  Future<void> _joinSocketRoom(String chatId) async {
    try {
      debugPrint('Joining socket room: $chatId');
      await socketDataSource.joinRoom(chatId);
      _connectedChatId = chatId;
      debugPrint('Successfully joined socket room: $chatId');
    } catch (e) {
      debugPrint('Failed to join socket room: $e');
      // Don't throw here, just log the error
    }
  }

  // Update cache with new data
  void _updateCache(
    String chatId,
    ChatEntity chat,
    List<MessageEntity> messages,
  ) {
    try {
      // Update memory cache
      _memoryCache[chatId] = ChatCacheData(
        chat: chat,
        messages: List.from(messages),
        lastUpdated: DateTime.now(),
      );

      // Update persistent cache
      // ChatCacheManager.cacheChat(
      //   chatId: chatId,
      //   chat: chat,
      //   messages: messages,
      // );

      debugPrint('Updated cache for chat: $chatId');
    } catch (e) {
      debugPrint('Error updating cache: $e');
    }
  }

  // Send text message
  Future<void> sendTextMessage(String chatId) async {
    final content = messageController.text.trim();
    if (content.isEmpty || _isSending) return;
    if (!canSendMessages) {
      _setError('You cannot send messages to this chat');
      return;
    }
    if (!isSocketConnected) {
      _setError('Not connected to chat server. Reconnecting...');
      try {
        await _ensureSocketConnection();
        await _joinSocketRoom(chatId);
      } catch (e) {
        _setError('Failed to connect to chat server');
        return;
      }
    }
    _setSending(true);
    messageController.clear();
    try {
      final result = await sendMessage(
        SendMessageParams(chatId: chatId, content: content),
      );
      result.fold((failure) => _setError(failure.message), (message) {
        _addOptimisticMessage(message);
        _updateCacheWithNewMessage(chatId, message);
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
    if (!canSendMessages) {
      _setError('You cannot send media to this chat');
      return;
    }
    if (!isSocketConnected) {
      _setError('Not connected to chat server. Please reconnect.');
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
          _updateCacheWithNewMessage(chatId, message);
        });
      });
    } catch (e) {
      _setError(e.toString());
    }
    _setUploading(false);
  }

  // Join group or bot
  Future<void> joinGroupOrBot(String chatId) async {
    if (_isLoading) return;
    _setLoading(true);
    try {
      final result = await chatRepository.joinGroup(chatId);
      result.fold((failure) => _setError(failure.message), (_) {
        // Clear cache for this chat so fresh data is loaded
        _clearChatCache(chatId);
        initializeChat(chatId);
        _setError(null);
      });
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  // Reconnect and rejoin room
  Future<void> reconnectAndRejoin() async {
    if (_currentChatId == null) return;

    _setConnecting(true);
    try {
      await socketDataSource.connect();
      await _joinSocketRoom(_currentChatId!);
      _setupMessageListener(_currentChatId!);
      debugPrint('Successfully reconnected and rejoined room');
    } catch (e) {
      debugPrint('Failed to reconnect and rejoin: $e');
      _setError('Failed to reconnect: $e');
    } finally {
      _setConnecting(false);
    }
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
        await sendMediaMessage(chatId, file, extension.substring(1));
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

  // Cache management methods
  void _updateCacheWithNewMessage(String chatId, MessageEntity message) {
    try {
      // Update memory cache
      if (_memoryCache.containsKey(chatId)) {
        final existingIndex = _memoryCache[chatId]!.messages.indexWhere(
          (m) => m.id == message.id,
        );
        if (existingIndex != -1) {
          _memoryCache[chatId]!.messages[existingIndex] = message;
        } else {
          _memoryCache[chatId]!.messages.add(message);
        }
        _memoryCache[chatId]!.lastUpdated = DateTime.now();
      }

      // Update persistent cache
      // ChatCacheManager.addMessageToCache(chatId, message);
    } catch (e) {
      debugPrint('Error updating cache with new message: $e');
    }
  }

  void _clearChatCache(String chatId) {
    _memoryCache.remove(chatId);
    // ChatCacheManager.removeCachedChat(chatId);
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      _messages.removeWhere((message) => message.id == messageId);

      // Update cache
      if (_currentChatId != null && _memoryCache.containsKey(_currentChatId)) {
        _memoryCache[_currentChatId]!.messages.removeWhere(
          (message) => message.id == messageId,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to delete message: $e');
      if (_currentChatId != null) {
        initializeChat(_currentChatId!);
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

  // Refresh chat
  Future<void> refreshChat(String chatId) async {
    _clearChatCache(chatId);
    await initializeChat(chatId);
  }

  // Private methods
  void _onNewMessage(MessageEntity message) {
    // Only process if this message is for the current chat
    if (_currentChatId == null || message.chatId != _currentChatId) {
      debugPrint('Ignoring message for different chat: ${message.chatId}');
      return;
    }

    debugPrint('Processing new message for current chat: ${message.id}');

    // Check if message already exists
    final existingIndex = _messages.indexWhere((m) => m.id == message.id);

    if (existingIndex != -1) {
      _messages[existingIndex] = message;
      debugPrint('Updated existing message: ${message.id}');
    } else {
      _messages.add(message);
      debugPrint('Added new message: ${message.id}');
    }

    // Update cache
    _updateCacheWithNewMessage(_currentChatId!, message);

    _scrollToBottom();
    notifyListeners();

    // Mark as read if not from current user
    if (!message.isCurrentUser) {
      markMessagesAsRead();
    }
  }

  void _addOptimisticMessage(MessageEntity message) {
    // Only add if this is for the current chat
    if (_currentChatId == null || message.chatId != _currentChatId) {
      return;
    }

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

  void _setConnecting(bool connecting) {
    _isConnecting = connecting;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Public utility methods
  void clearError() {
    _clearError();
  }

  void scrollToBottom() {
    _scrollToBottom();
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

  @override
  void dispose() {
    debugPrint('Disposing ChatProvider');

    // Clear current chat
    _clearCurrentChat();

    // Stop recording timer
    _recordingTimer?.cancel();

    // Dispose controllers and resources
    _audioRecorder.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();

    // Disconnect socket
    socketDataSource.disconnect().catchError((e) {
      debugPrint('Error disconnecting socket on dispose: $e');
    });

    super.dispose();
  }
}
