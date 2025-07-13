import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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

  // Track pending messages to prevent duplicates
  final Set<String> _pendingMessages = <String>{};

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

  // Auto-scroll management
  bool _shouldAutoScroll = true;
  bool _isUserScrolling = false;
  Timer? _scrollTimer;

  // Initialize cache
  Future<void> _initializeCache() async {
    try {
      debugPrint('Chat cache initialized');
      scrollController.addListener(_onScrollChanged);
    } catch (e) {
      debugPrint('Failed to initialize cache: $e');
    }
  }

  // Enhanced scroll change detection
  void _onScrollChanged() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    const threshold = 100.0;

    if (scrollController.position.userScrollDirection != ScrollDirection.idle) {
      _isUserScrolling = true;

      if ((maxScroll - currentScroll) > threshold) {
        _shouldAutoScroll = false;
        debugPrint('Auto-scroll disabled - user scrolled up');
      }
    }

    if ((maxScroll - currentScroll) <= 50.0) {
      if (!_shouldAutoScroll) {
        debugPrint('Auto-scroll re-enabled - user at bottom');
      }
      _shouldAutoScroll = true;
      _isUserScrolling = false;
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

    _messageSubscription?.cancel();
    _messageSubscription = null;

    if (_connectedChatId != null) {
      socketDataSource.leaveRoom(_connectedChatId!).catchError((e) {
        debugPrint('Error leaving room: $e');
      });
      _connectedChatId = null;
    }

    final previousChatId = _currentChatId;
    _currentChatId = null;
    _messages.clear();
    _currentChat = null;
    _pendingMessages.clear(); // Clear pending messages
    _clearError();

    _shouldAutoScroll = true;
    _isUserScrolling = false;
    _scrollTimer?.cancel();
    _scrollTimer = null;

    messageController.clear();

    debugPrint('Cleared chat state for: $previousChatId');
    notifyListeners();
  }

  Future<void> initializeChat(String chatId) async {
    if (_currentChatId != null && _currentChatId != chatId) {
      debugPrint('Switching from $_currentChatId to $chatId');
      _clearCurrentChat();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (_currentChatId == chatId && _messages.isNotEmpty) {
      debugPrint('Chat already initialized for $chatId, ensuring connection');
      await _ensureSocketConnection();
      await _joinSocketRoom(chatId);
      if (_messageSubscription == null) {
        _setupMessageListener(chatId);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomImmediate();
      });
      return;
    }

    _currentChatId = chatId;
    setLoading(true);
    _clearError();
    _shouldAutoScroll = true;
    _isUserScrolling = false;
    ChatCacheData? cachedData;

    try {
      try {
        cachedData = _memoryCache[chatId];
      } catch (e) {
        debugPrint('Error loading from cache: $e');
      }

      if (cachedData != null && !cachedData.isExpired()) {
        debugPrint('Loading chat from cache: $chatId');
        _currentChat = cachedData.chat;
        _messages = List.from(cachedData.messages);
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottomImmediate();
          Timer(const Duration(milliseconds: 100), () {
            _scrollToBottomImmediate();
          });
        });
      }

      await _ensureSocketConnection();
      await _joinSocketRoom(chatId);
      _setupMessageListener(chatId);

      final result = await fetchChatWithMessages(
        FetchChatWithMessagesParams(chatId: chatId),
      );

      result.fold(
        (failure) {
          if (cachedData == null) {
            _setError(failure.message);
          }
        },
        (data) {
          _currentChat = data['chat'] as ChatEntity;
          _messages = data['messages'] as List<MessageEntity>;
          _updateCache(chatId, _currentChat!, _messages);
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottomImmediate();
            Timer(const Duration(milliseconds: 100), () {
              _scrollToBottomSmooth();
            });
            Timer(const Duration(milliseconds: 300), () {
              _scrollToBottomImmediate();
            });
          });
        },
      );
    } catch (e) {
      if (cachedData == null) {
        _setError(e.toString());
      }
    }

    setLoading(false);
    debugPrint('=== Chat initialization complete: $chatId ===');
  }

  void _setupMessageListener(String chatId) {
    _messageSubscription?.cancel();
    _messageSubscription = chatRepository
        .listenToNewMessages(chatId)
        .listen(
          (message) {
            if (_currentChatId == chatId && message.chatId == chatId) {
              _onNewMessage(message);
            } else {
              debugPrint(
                'Ignoring message - chatId mismatch. Message: ${message.chatId}, Current: $_currentChatId, Expected: $chatId',
              );
            }
          },
          onError: (error) {
            if (_currentChatId == chatId) {
              _setError('Connection error: $error');
            }
          },
          onDone: () {
            debugPrint('Message stream closed for chat: $chatId');
          },
        );
  }

  Future<void> _ensureSocketConnection() async {
    if (!isSocketConnected) {
      _setConnecting(true);
      try {
        await socketDataSource.connect();
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        _setError('Failed to connect to chat server. Please try again.');
        rethrow;
      } finally {
        _setConnecting(false);
      }
    }
  }

  Future<void> _joinSocketRoom(String chatId) async {
    try {
      await socketDataSource.joinRoom(chatId);
      _connectedChatId = chatId;
      debugPrint('Successfully joined socket room: $chatId');
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('Failed to join socket room: $e');
    }
  }

  // Enhanced new message handling with duplicate prevention
  void _onNewMessage(MessageEntity message) {
    if (_currentChatId == null || message.chatId != _currentChatId) {
      debugPrint(
        'Ignoring message for different chat: ${message.chatId} (current: $_currentChatId)',
      );
      return;
    }

    // Check if this is a pending message (sent by current user)
    if (_pendingMessages.contains(message.id)) {
      debugPrint('Removing pending message: ${message.id}');
      _pendingMessages.remove(message.id);

      // Find and update the optimistic message
      final existingIndex = _messages.indexWhere(
        (m) =>
            m.senderId == message.senderId &&
            m.content == message.content &&
            m.createdAt.difference(message.createdAt).abs().inMinutes < 1,
      );

      if (existingIndex != -1) {
        _messages[existingIndex] = message;
        debugPrint(
          'Updated optimistic message with server response: ${message.id}',
        );
      } else {
        _messages.add(message);
        debugPrint('Added message from server: ${message.id}');
      }
    } else {
      // Check for existing message by ID
      final existingIndex = _messages.indexWhere((m) => m.id == message.id);
      if (existingIndex != -1) {
        _messages[existingIndex] = message;
        debugPrint('Updated existing message: ${message.id}');
      } else {
        _messages.add(message);
        debugPrint('Added new message: ${message.id}');
      }
    }

    _updateCacheWithNewMessage(_currentChatId!, message);
    notifyListeners();

    if (_shouldAutoScroll && !_isUserScrolling) {
      debugPrint('Auto-scrolling to new message');
      _scrollToBottomSmooth();
    } else {
      debugPrint(
        'Not auto-scrolling - shouldAutoScroll: $_shouldAutoScroll, isUserScrolling: $_isUserScrolling',
      );
    }

    if (!message.isCurrentUser) {
      markMessagesAsRead();
    }
  }

  // Enhanced optimistic message handling
  void _addOptimisticMessage(MessageEntity message) {
    if (_currentChatId == null || message.chatId != _currentChatId) {
      debugPrint('Not adding optimistic message - chat mismatch');
      return;
    }

    // Add to pending messages set
    _pendingMessages.add(message.id);

    _messages.add(message);
    _shouldAutoScroll = true;
    notifyListeners();
    _scrollToBottomSmooth();

    debugPrint('Added optimistic message: ${message.id}');
  }

  void _scrollToBottomImmediate() {
    if (!scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomImmediate();
      });
      return;
    }
    try {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      debugPrint('Immediate scroll to bottom completed');
    } catch (e) {
      debugPrint('Error in immediate scroll: $e');
    }
  }

  void _scrollToBottomSmooth() {
    if (!_shouldAutoScroll && !_isSending) return;
    _scrollTimer?.cancel();
    final delay = _messages.isEmpty
        ? const Duration(milliseconds: 300)
        : const Duration(milliseconds: 100);

    _scrollTimer = Timer(delay, () {
      if (!scrollController.hasClients) {
        _scrollTimer = Timer(const Duration(milliseconds: 500), () {
          _performScroll();
        });
        return;
      }
      _performScroll();
    });
  }

  void _performScroll() {
    if (!scrollController.hasClients) return;
    try {
      final maxScroll = scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        scrollController
            .animateTo(
              maxScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
            .then((_) {
              debugPrint('Smooth scroll to bottom completed');
            })
            .catchError((e) {
              debugPrint('Error in smooth scroll: $e');
            });
      }
    } catch (e) {
      debugPrint('Error initiating smooth scroll: $e');
    }
  }

  // Send text message with enhanced auto-scroll and duplicate prevention
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

    _shouldAutoScroll = true;
    _isUserScrolling = false;

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

  // Send media message with enhanced auto-scroll and duplicate prevention
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
    _shouldAutoScroll = true;
    _isUserScrolling = false;

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
    setLoading(true);
    try {
      final result = await chatRepository.joinGroup(chatId);
      result.fold((failure) => _setError(failure.message), (_) {
        _clearChatCache(chatId);
        initializeChat(chatId);
        _setError(null);
      });
    } catch (e) {
      _setError(e.toString());
    }
    setLoading(false);
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

  // Update cache with new data
  void _updateCache(
    String chatId,
    ChatEntity chat,
    List<MessageEntity> messages,
  ) {
    try {
      _memoryCache[chatId] = ChatCacheData(
        chat: chat,
        messages: List.from(messages),
        lastUpdated: DateTime.now(),
      );
      debugPrint('Updated cache for chat: $chatId');
    } catch (e) {
      debugPrint('Error updating cache: $e');
    }
  }

  // Update cache with new message
  void _updateCacheWithNewMessage(String chatId, MessageEntity message) {
    try {
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
    } catch (e) {
      debugPrint('Error updating cache with new message: $e');
    }
  }

  void _clearChatCache(String chatId) {
    _memoryCache.remove(chatId);
  }

  // Refresh chat
  Future<void> refreshChat(String chatId) async {
    _clearChatCache(chatId);
    await initializeChat(chatId);
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

  void setLoading(bool loading) {
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
    _shouldAutoScroll = true;
    _isUserScrolling = false;
    _scrollToBottomSmooth();
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

    _clearCurrentChat();

    _recordingTimer?.cancel();
    _scrollTimer?.cancel();

    _audioRecorder.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();

    socketDataSource.disconnect().catchError((e) {
      debugPrint('Error disconnecting socket on dispose: $e');
    });

    super.dispose();
  }
}
