import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

const _chatDetailTextColor = Color(0xFF3B0C56);
const _chatDetailBackground = Color(0xFFF7F7FA);
const _chatDetailBottomBarBackground = Color(0xFFF0F0F5);

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.name,
    required this.avatarSeed,
  });

  final String name;
  final int avatarSeed;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  late final List<_ChatMessage> _messages = _buildMessages(widget.name);

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
          child: Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: _chatDetailBackground),
              ),
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFFFFF),
                        Color(0x00FFFFFF),
                      ],
                      stops: [0.0, 0.62, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFEAF5FF),
                          Color(0xFFF5EDFF),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
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
                                onSubmitted: (_) {},
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.send_rounded,
                                color: brand.seedColor,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ],
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

  final _ChatMessage message;
  final int avatarSeed;
  final AppBrandTheme brand;

  @override
  Widget build(BuildContext context) {
    final avatar = _ChatAvatar(
      avatarSeed: message.isMine ? avatarSeed + 50 : avatarSeed,
      brand: brand,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: message.isMine ? brand.seedColor : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isMine ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
            ),
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

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
  });

  final String text;
  final bool isMine;
}

List<_ChatMessage> _buildMessages(String name) {
  switch (name) {
    case '丹妮尔':
      return const [
        _ChatMessage(text: '今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？', isMine: false),
        _ChatMessage(text: '今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？今天过得怎么样？', isMine: false),
        _ChatMessage(text: '还不错，刚忙完。', isMine: true),
        _ChatMessage(text: '那就好，晚上想聊聊吗？', isMine: false),
        _ChatMessage(text: '可以呀，我晚点有空。', isMine: true),
        _ChatMessage(text: '那我等你消息。', isMine: false),
      ];
    case '王嘉尔':
      return const [
        _ChatMessage(text: '那就好，别生气了，咱们继续聊聊你最近在忙什么？', isMine: false),
        _ChatMessage(text: '好的', isMine: true),
        _ChatMessage(text: '我挺好奇的，说说看，我听着呢。', isMine: false),
        _ChatMessage(text: '那你就等着吧', isMine: true),
        _ChatMessage(text: '哈哈，好，我等着你呢，反正我闲着也是闲着。', isMine: false),
        _ChatMessage(text: '你这话说一半吊我胃口，是不是有什么惊喜要分享？', isMine: false),
      ];
    default:
      return const [
        _ChatMessage(text: '你好呀。', isMine: false),
        _ChatMessage(text: '你好。', isMine: true),
      ];
  }
}
