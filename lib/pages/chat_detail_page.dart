import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_2/models/chat_models.dart';
import 'package:flutter_application_2/network/app_network.dart';
import 'package:flutter_application_2/theme/app_theme.dart';
import 'package:flutter_application_2/widgets/app_page_background.dart';
import 'package:flutter_application_2/widgets/app_button.dart';

const _chatDetailTextColor = AppColors.textPrimary;
const _chatDetailBackground = AppColors.pageBackground;
const _chatDetailBottomBarBackground = AppColors.chatBottomBarBackground;

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.name,
    required this.avatarSeed,
    required this.sessionId,
  });

  final String name;
  final int avatarSeed;
  final int sessionId;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  final List<ChatMessage> _messages = <ChatMessage>[];
  StreamSubscription<String>? _streamSub;
  CancelToken? _cancelToken;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        _scheduleScrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _cancelToken?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _inputFocusNode.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0 && _inputFocusNode.hasFocus) {
      _scheduleScrollToBottom();
    }
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToBottom();
      Future<void>.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return;
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;
    final pos = _scrollController.position;
    return (pos.maxScrollExtent - pos.pixels) < 80;
  }

  void _send() {
    if (_sending) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final userMsg = ChatMessage(
      id: newChatMessageId(),
      role: ChatRole.user,
      content: text,
      createdAt: now,
      status: ChatMessageStatus.complete,
    );
    final assistantId = newChatMessageId();
    final assistantMsg = ChatMessage(
      id: assistantId,
      role: ChatRole.assistant,
      content: '',
      createdAt: now,
      status: ChatMessageStatus.generating,
    );

    final shouldScroll = _isNearBottom();
    setState(() {
      _messages.add(userMsg);
      _messages.add(assistantMsg);
      _sending = true;
    });
    if (shouldScroll) _scheduleScrollToBottom();

    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    _streamSub?.cancel();

    final payload = <String, dynamic>{
      'max_tokens': 1024,
      'model': 'qwen-plus',
      'temperature': 0.5,
      'top_p': 1,
      'presence_penalty': 0,
      'frequency_penalty': 0,
      'messages': _messages
          .where((m) => m.status != ChatMessageStatus.generating)
          .map((m) => {
                'role': m.role == ChatRole.user ? 'user' : 'assistant',
                'content': m.content,
              })
          .toList(),
      'stream': true,
      'kid': '',
      'chat_type': 0,
      'appId': '',
      'hasAttachment': false,
      'autoSelectModel': false,
      'sessionId': widget.sessionId,
    };

    _streamSub = AppNetwork.chat
        .sendStream(payload: payload, cancelToken: _cancelToken)
        .listen(
      (chunk) {
        final idx = _messages.lastIndexWhere((m) => m.id == assistantId);
        if (idx < 0) return;
        final shouldScroll2 = _isNearBottom();
        setState(() {
          final cur = _messages[idx];
          _messages[idx] = cur.copyWith(content: cur.content + chunk);
        });
        if (shouldScroll2) _scheduleScrollToBottom();
      },
      onError: (_) {
        final idx = _messages.lastIndexWhere((m) => m.id == assistantId);
        if (idx >= 0) {
          setState(() {
            _messages[idx] = _messages[idx].copyWith(status: ChatMessageStatus.error);
            _sending = false;
          });
        } else {
          setState(() => _sending = false);
        }
      },
      onDone: () {
        final idx = _messages.lastIndexWhere((m) => m.id == assistantId);
        if (idx >= 0) {
          setState(() {
            final cur = _messages[idx];
            _messages[idx] = cur.content.isEmpty
                ? cur.copyWith(
                    status: ChatMessageStatus.error,
                    content: '（无输出）',
                  )
                : cur.copyWith(status: ChatMessageStatus.complete);
            _sending = false;
          });
        } else {
          setState(() => _sending = false);
        }
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = AppBrandTheme.of(context);

    const uiStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: _chatDetailBottomBarBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: uiStyle,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: _chatDetailBackground,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: AppPageBackground(
            child: SafeArea(
              child: Column(
                  children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Row(
                      children: [
                        _HeaderIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _chatDetailTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _HeaderIconButton(
                          icon: Icons.density_medium,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: _MessageRow(
                            message: message,
                            avatarSeed: widget.avatarSeed,
                            brand: brand,
                          ),
                        );
                      },
                    ),
                  ),
                  ColoredBox(
                    color: _chatDetailBottomBarBackground,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: _controller,
                                focusNode: _inputFocusNode,
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  hintText: '请输入',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB7B7C6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                                textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _send(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppSquareIconButton(
                            width: 40,
                            height: 40,
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.send_rounded,
                              color: brand.seedColor,
                              size: 22,
                            ),
                            onTap: _send,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 38,
        width: 38,
        child: Icon(icon, color: _chatDetailTextColor, size: 22),
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({
    required this.message,
    required this.avatarSeed,
    required this.brand,
  });

  final ChatMessage message;
  final int avatarSeed;
  final AppBrandTheme brand;

  @override
  Widget build(BuildContext context) {
    final avatar = _ChatAvatar(
      avatarSeed: message.isMine ? avatarSeed + 50 : avatarSeed,
      brand: brand,
    );

    final bubbleChild = (message.status == ChatMessageStatus.generating &&
            message.content.isEmpty)
        ? SizedBox(
            width: 44,
            height: 20,
            child: Center(
              child: SpinKitThreeBounce(
                color: message.isMine ? Colors.white : brand.seedColor,
                size: 12,
              ),
            ),
          )
        : Text(
            message.content,
            style: TextStyle(
              color: message.isMine ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.4,
            ),
          );

    return Row(
      mainAxisAlignment:
          message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isMine) ...[
          avatar,
          const SizedBox(width: 10),
        ],
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.90,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: message.isMine ? brand.seedColor : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: bubbleChild,
                ),
              );
            },
          ),
        ),
        if (message.isMine) ...[
          const SizedBox(width: 10),
          avatar,
        ],
      ],
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({
    required this.avatarSeed,
    required this.brand,
  });

  final int avatarSeed;
  final AppBrandTheme brand;

  @override
  Widget build(BuildContext context) {
    final avatarColor = Color.lerp(
          brand.accentColor.withValues(alpha: 0.40),
          brand.seedColor.withValues(alpha: 0.18),
          (avatarSeed % 10) / 10.0,
        ) ??
        brand.seedColor.withValues(alpha: 0.22);

    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: avatarColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

// Live streaming messages are handled via `/chat/send` SSE.
