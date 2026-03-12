import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_application_2/icons/remix_icons.dart';
import 'package:flutter_application_2/pages/chat_detail_page.dart';
import 'package:flutter_application_2/theme/app_theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = AppBrandTheme.of(context);

    return Stack(
      children: [
        // Base: light grey-white, close to the bottom nav background.
        const Positioned.fill(
          child: ColoredBox(color: Color(0xFFF7F7FA)),
        ),
        // Top area: left (very light blue) -> right (light purple),
        // and fades out downward to keep the lower part nearly solid grey-white.
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
                    Color(0xFFEAF5FF), // left: light blue, near white
                    Color(0xFFF5EDFF), // right: light purple
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B0C56),
                      ),
                    ),
                    const Spacer(),
                    _SquareIconButton(
                      icon: RemixIcons.userAddLine,
                      iconSize: 22,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SlidableAutoCloseBehavior(
                    child: ListView.separated(
                      itemCount: 2,
                      separatorBuilder: (_, _) => const SizedBox(height: 22),
                      itemBuilder: (context, index) {
                        final item = _demoItems[index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            const buttonSize = 74.0;
                            const sidePadding = 6.0; // matches _SlideSquareAction outer padding
                            final desiredWidth =
                                (buttonSize * 2) + (sidePadding * 2) + (sidePadding * 2);
                            final extentRatio =
                                (desiredWidth / constraints.maxWidth).clamp(0.0, 1.0).toDouble();

                            return Slidable(
                              key: ValueKey('chat_${item.name}_$index'),
                              groupTag: _chatSlidableGroupTag,
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                extentRatio: extentRatio,
                                children: [
                                  _SlideActionsPane(
                                    primaryColor: brand.seedColor,
                                    onPinTap: () {},
                                    onDeleteTap: () {},
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => ChatDetailPage(
                                        name: item.name,
                                        avatarSeed: item.avatarSeed,
                                      ),
                                    ),
                                  );
                                },
                                child: _ChatRow(
                                  brand: brand,
                                  name: item.name,
                                  preview: item.preview,
                                  date: item.date,
                                  unread: item.unread,
                                  avatarSeed: item.avatarSeed,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    required this.onTap,
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: iconSize, color: const Color(0xFF3A3A3A)),
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.brand,
    required this.name,
    required this.preview,
    required this.date,
    required this.unread,
    required this.avatarSeed,
  });

  final AppBrandTheme brand;
  final String name;
  final String preview;
  final String date;
  final int unread;
  final int avatarSeed;

  @override
  Widget build(BuildContext context) {
    final avatarColor = Color.lerp(
          brand.accentColor.withValues(alpha: 0.40),
          brand.seedColor.withValues(alpha: 0.18),
          (avatarSeed % 10) / 10.0,
        ) ??
        brand.seedColor.withValues(alpha: 0.22);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF3B0C56),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: const TextStyle(
                color: Color(0xFFB9B9B9),
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: brand.seedColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SlideActionsPane extends StatelessWidget {
  const _SlideActionsPane({
    required this.primaryColor,
    required this.onPinTap,
    required this.onDeleteTap,
  });

  final Color primaryColor;
  final VoidCallback onPinTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SlideSquareActionButton(
              backgroundColor: primaryColor,
              icon: Icons.star_outline_rounded,
              onTap: onPinTap,
            ),
            const SizedBox(width: 12),
            _SlideSquareActionButton(
              backgroundColor: const Color(0xFFF25C5C),
              icon: Icons.close_rounded,
              onTap: onDeleteTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideSquareActionButton extends StatelessWidget {
  const _SlideSquareActionButton({
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });

  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 74,
        width: 74,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, size: 30, color: Colors.white),
      ),
    );
  }
}

class _ChatItem {
  const _ChatItem({
    required this.name,
    required this.preview,
    required this.date,
    required this.unread,
    required this.avatarSeed,
  });

  final String name;
  final String preview;
  final String date;
  final int unread;
  final int avatarSeed;
}

const _chatSlidableGroupTag = 'chat_list_slidable_group';

const List<_ChatItem> _demoItems = [
  _ChatItem(
    name: '丹妮尔',
    preview: '【爱意】',
    date: '2/24/2026',
    unread: 2,
    avatarSeed: 1,
  ),
  _ChatItem(
    name: '王嘉尔',
    preview: '别让我等太久哦，我可好奇…',
    date: '2/24/2026',
    unread: 1,
    avatarSeed: 2,
  ),
];


