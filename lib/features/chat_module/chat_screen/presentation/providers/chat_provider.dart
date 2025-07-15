import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../../core/services/storage_service.dart';
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

  String? _currentChatId;
  ChatType _currentChatType = ChatType.community;
  List<MessageEntity> _messages = [];
  ChatEntity? _currentChat;
  bool _isLoading = false;
  bool _isRecording = false;
  bool _isUploading = false;
  bool _isSending = false;
  bool _isConnecting = false;
  String? _error;

  // Enhanced optimistic message handling
  final Map<String, MessageEntity> _optimisticMessages =
      <String, MessageEntity>{};
  final Set<String> _processedMessageIds = <String>{};
  final Map<String, Timer> _optimisticTimers = <String, Timer>{};

  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  StreamSubscription<MessageEntity>? _messageSubscription;
  String? _connectedChatId;

  bool _shouldAutoScroll = true;
  bool _isUserScrolling = false;
  Timer? _scrollTimer;
  bool _isInitializing = false;

  Future<void> _initializeCache() async {
    try {
      scrollController.addListener(_onScrollChanged);
    } catch (e) {
      // Error handled silently
    }
  }

  void _onScrollChanged() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    const threshold = 100.0;

    if (scrollController.position.userScrollDirection != ScrollDirection.idle) {
      _isUserScrolling = true;

      if ((maxScroll - currentScroll) > threshold) {
        _shouldAutoScroll = false;
      }
    }

    if ((maxScroll - currentScroll) <= 50.0) {
      _shouldAutoScroll = true;
      _isUserScrolling = false;
    }
  }

  List<MessageEntity> get messages => _messages;
  ChatEntity? get currentChat => _currentChat;
  String? get currentChatId => _currentChatId;
  ChatType get currentChatType => _currentChatType;
  bool get isLoading => _isLoading;
  bool get isRecording => _isRecording;
  bool get isUploading => _isUploading;
  bool get isSending => _isSending;
  bool get isConnecting => _isConnecting;
  String? get error => _error;
  int get recordingDuration => _recordingDuration;
  bool get hasText => messageController.text.trim().isNotEmpty;
  bool get isBotChat => _currentChat?.isBot ?? false;
  bool get canSendMessages {
    if (_currentChatType == ChatType.personal) return true;
    return _currentChat?.isCreator == true ||
        _currentChat?.isUserInGroup == true;
  }

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

  void _clearCurrentChat() {
    if (_isInitializing) return;

    _messageSubscription?.cancel();
    _messageSubscription = null;

    if (_connectedChatId != null) {
      socketDataSource.leaveRoom(_connectedChatId!).catchError((e) {});
      _connectedChatId = null;
    }

    // Clear all optimistic message timers
    _optimisticTimers.forEach((key, timer) => timer.cancel());
    _optimisticTimers.clear();

    _currentChatId = null;
    _currentChatType = ChatType.community;
    _messages.clear();
    _currentChat = null;
    _optimisticMessages.clear();
    _processedMessageIds.clear();
    _clearError();

    _shouldAutoScroll = true;
    _isUserScrolling = false;
    _scrollTimer?.cancel();
    _scrollTimer = null;

    messageController.clear();
    notifyListeners();
  }

  Future<void> initializeChat(
    String chatId, {
    ChatType chatType = ChatType.community,
  }) async {
    if (_isInitializing) return;
    if (_currentChatId != null && _currentChatId != chatId) {
      _clearCurrentChat();
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (_currentChatId == chatId &&
        _currentChatType == chatType &&
        _messages.isNotEmpty) {
      await _ensureSocketConnection();
      await _joinSocketRoom(chatId, chatType);
      if (_messageSubscription == null) {
        _setupMessageListener(chatId);
      }
      _scrollToBottomIfNeeded();
      return;
    }
    _isInitializing = true;
    _currentChatId = chatId;
    _currentChatType = chatType;
    setLoading(true);
    _clearError();
    _shouldAutoScroll = true;
    _isUserScrolling = false;
    _messages.clear();
    _currentChat = null;
    notifyListeners();

    ChatCacheData? cachedData;
    try {
      try {
        cachedData = _memoryCache[chatId];
        if (cachedData != null && cachedData.isExpired()) {
          _memoryCache.remove(chatId);
          cachedData = null;
        }
      } catch (e) {
        // Cache error handled
      }

      if (cachedData != null) {
        _currentChat = cachedData.chat;
        _messages = List.from(cachedData.messages);
        notifyListeners();
        _scrollToBottomIfNeeded();
      }

      await _ensureSocketConnection();
      await _joinSocketRoom(chatId, chatType);
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
          if (_currentChatId == chatId) {
            _currentChat = data['chat'] as ChatEntity;
            final newMessages = data['messages'] as List<MessageEntity>;
            _messages.clear();
            _messages.addAll(newMessages);
            _processedMessageIds.clear();
            for (final message in newMessages) {
              _processedMessageIds.add(message.id);
            }
            _updateCache(chatId, _currentChat!, _messages);
            notifyListeners();
            _scrollToBottomIfNeeded();
          }
        },
      );
    } catch (e) {
      if (cachedData == null && _currentChatId == chatId) {
        _setError(e.toString());
      }
    }

    setLoading(false);
    _isInitializing = false;
  }

  void _setupMessageListener(String chatId) {
    _messageSubscription?.cancel();
    _messageSubscription = chatRepository
        .listenToNewMessages(chatId)
        .listen(
          (message) {
            if (_currentChatId == chatId && message.chatId == chatId) {
              _onNewMessage(message);
            }
          },
          onError: (error) {
            if (_currentChatId == chatId) {
              _setError('Connection error: $error');
            }
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

  Future<void> _joinSocketRoom(String chatId, ChatType chatType) async {
    try {
      await socketDataSource.joinRoom(chatId, chatType: chatType);
      _connectedChatId = chatId;
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Error handled silently
    }
  }

  void _onNewMessage(MessageEntity message) {
    if (StorageService.userId == message.senderId) {
      return;
    }
    if (_currentChatId == null || message.chatId != _currentChatId) {
      return;
    }
    if (_processedMessageIds.contains(message.id)) {
      return;
    }
    final existingIndex = _messages.indexWhere((m) => m.id == message.id);
    if (existingIndex != -1) {
      _messages[existingIndex] = message;
    } else {
      _messages.add(message);
      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    _processedMessageIds.add(message.id);
    _updateCacheWithNewMessage(_currentChatId!, message);
    notifyListeners();
    if (_shouldAutoScroll && !_isUserScrolling) {
      _scrollToBottomSmooth();
    }
    if (!message.isCurrentUser) {
      markMessagesAsRead();
    }
  }

  void _addOptimisticMessage(MessageEntity message) {
    if (_currentChatId == null || message.chatId != _currentChatId) {
      return;
    }
    final optimisticId =
        'optimistic_${DateTime.now().millisecondsSinceEpoch}_${message.content.hashCode}';
    final optimisticMessage = MessageEntity(
      id: optimisticId,
      chatId: message.chatId,
      senderId: message.senderId,
      senderName: message.senderName,
      senderImage: message.senderImage,
      content: message.content,
      mediaUrl: message.mediaUrl,
      mediaType: message.mediaType,
      createdAt: message.createdAt,
      isDeleted: message.isDeleted,
      isCurrentUser: message.isCurrentUser,
    );
    _optimisticMessages[optimisticId] = optimisticMessage;
    _messages.add(optimisticMessage);
    _shouldAutoScroll = true;
    notifyListeners();
    _scrollToBottomSmooth();
    _optimisticTimers[optimisticId] = Timer(const Duration(seconds: 30), () {
      _optimisticMessages.remove(optimisticId);
      _optimisticTimers.remove(optimisticId);
      _messages.removeWhere((m) => m.id == optimisticId);
      notifyListeners();
    });
  }

  void _scrollToBottomIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottomImmediate();
      Timer(const Duration(milliseconds: 100), () {
        _scrollToBottomImmediate();
      });
    });
  }

  void _scrollToBottomImmediate() {
    if (!scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomImmediate();
      });
      return;
    }
    try {
      if (scrollController.position.maxScrollExtent > 0) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    } catch (e) {
      // Error handled silently
    }
  }

  void _scrollToBottomSmooth() {
    if (!_shouldAutoScroll && !_isSending) return;

    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), () {
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
            .catchError((e) {});
      }
    } catch (e) {
      // Error handled silently
    }
  }

  Future<void> sendTextMessage(String chatId, {ChatType? chatType}) async {
    final content = messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    final messageType = chatType ?? _currentChatType;

    if (messageType == ChatType.community && !canSendMessages) {
      _setError('You cannot send messages to this chat');
      return;
    }

    if (!isSocketConnected) {
      _setError('Not connected to chat server. Reconnecting...');
      try {
        await _ensureSocketConnection();
        await _joinSocketRoom(chatId, messageType);
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
        SendMessageParams(
          chatId: chatId,
          content: content,
          chatType: messageType,
        ),
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

  Future<void> sendMediaMessage(
    String chatId,
    File file,
    String mediaType, {
    ChatType? chatType,
  }) async {
    if (_isUploading) return;

    final messageType = chatType ?? _currentChatType;

    if (messageType == ChatType.community && !canSendMessages) {
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
            chatType: messageType,
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

  Future<void> joinGroupOrBot(String chatId) async {
    if (_isLoading) return;
    setLoading(true);
    _clearError();
    try {
      final result = await chatRepository.joinGroup(chatId);
      await result.fold(
        (failure) async {
          _setError(failure.message);
        },
        (_) async {
          _clearChatCache(chatId);
          _setError(null);
          await forceRefreshChat(chatId);
          debugPrint('Joined group or bot successfully');
        },
      );
    } catch (e) {
      _setError('Failed to join group: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> forceRefreshChat(String chatId, {ChatType? chatType}) async {
    _setConnecting(true);
    final messageType = chatType ?? _currentChatType;
    if (_currentChatId == chatId) {
      _messages.clear();
      _currentChat = null;
      _processedMessageIds.clear();
    }
    await initializeChat(chatId, chatType: messageType);
    _setConnecting(false);
  }

  Future<void> reconnectAndRejoin() async {
    if (_currentChatId == null) return;
    _setConnecting(true);
    try {
      await socketDataSource.connect();
      await _joinSocketRoom(_currentChatId!, _currentChatType);
      _setupMessageListener(_currentChatId!);
    } catch (e) {
      _setError('Failed to reconnect: $e');
    } finally {
      _setConnecting(false);
    }
  }

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
    } catch (e) {
      // Cache error handled silently
    }
  }

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
      // Cache error handled silently
    }
  }

  void _clearChatCache(String chatId) {
    _memoryCache.remove(chatId);
  }

  Future<void> refreshChat(String chatId, {ChatType? chatType}) async {
    _clearChatCache(chatId);
    await initializeChat(chatId, chatType: chatType ?? _currentChatType);
  }

  Future<void> pickImage(
    String chatId, {
    bool fromCamera = false,
    ChatType? chatType,
  }) async {
    final messageType = chatType ?? _currentChatType;
    if (messageType == ChatType.community && !canSendMessages) {
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
          chatType: messageType,
        );
      }
    } catch (e) {
      _setError('Failed to pick image: $e');
    }
  }

  Future<void> pickFile(String chatId, {ChatType? chatType}) async {
    final messageType = chatType ?? _currentChatType;
    if (messageType == ChatType.community && !canSendMessages) {
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
        await sendMediaMessage(chatId, file, extension, chatType: messageType);
      }
    } catch (e) {
      _setError('Failed to pick file: $e');
    }
  }

  Future<void> startRecording() async {
    if (_currentChatType == ChatType.community && !canSendMessages) {
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

  Future<void> stopRecording(String chatId, {ChatType? chatType}) async {
    if (!_isRecording) return;
    try {
      await _audioRecorder.stop();
      _stopRecordingTimer();
      if (_recordingPath != null && _recordingDuration > 0) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await sendMediaMessage(chatId, file, 'm4a', chatType: chatType);
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
        initializeChat(_currentChatId!, chatType: _currentChatType);
      }
    }
  }

  Future<void> markMessagesAsRead() async {
    try {
      final unreadMessages = _messages
          .where((message) => !message.isCurrentUser && message.id.isNotEmpty)
          .toList();
      for (final message in unreadMessages) {
        await chatRepository.markMessageAsRead(message.id);
      }
    } catch (e) {
      // Error handled silently
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
    _clearCurrentChat();
    _recordingTimer?.cancel();
    _scrollTimer?.cancel();
    _optimisticTimers.forEach((key, timer) => timer.cancel());
    _optimisticTimers.clear();
    _audioRecorder.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    socketDataSource.disconnect().catchError((e) {});
    super.dispose();
  }
}
