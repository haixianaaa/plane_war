import 'package:flutter/material.dart';
import 'package:flutter_application_2/game/game_controller.dart';
import 'package:flutter_application_2/game/models/game_models.dart';
import 'package:flutter_application_2/game/widgets/game_canvas.dart';

/// 游戏主页面。
///
/// 包含游戏画布、UI 元素（得分、生命值）和游戏控制按钮。
/// 使用深空主题，配合精美渐变和光效。
class GamePage extends StatefulWidget {
  /// 创建游戏页面实例
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  /// 游戏控制器
  late GameController _gameController;

  /// 标题动画控制器
  late AnimationController _titleAnimController;

  /// 背景粒子动画控制器
  late AnimationController _particleAnimController;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();

    _titleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _particleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _titleAnimController.dispose();
    _particleAnimController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gameController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF020515),
                  Color(0xFF0A0E2A),
                  Color(0xFF101540),
                  Color(0xFF0A0E2A),
                  Color(0xFF020515),
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_gameController.gameState == GameState.ready &&
                      _gameController.screenWidth == 0) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _gameController.initGame(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                    });
                  }

                  return Stack(
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          _gameController.movePlayer(
                            details.delta.dx,
                            details.delta.dy,
                          );
                        },
                        onPanStart: (details) {
                          if (_gameController.gameState == GameState.playing) {
                            _gameController.setPlayerPosition(
                              details.localPosition.dx,
                              details.localPosition.dy,
                            );
                          }
                        },
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: GameCanvas(
                            player: _gameController.player,
                            enemies: _gameController.enemies,
                            playerBullets: _gameController.playerBullets,
                            enemyBullets: _gameController.enemyBullets,
                            explosions: _gameController.explosions,
                            powerUps: _gameController.powerUps,
                            stars: _gameController.stars,
                          ),
                        ),
                      ),

                      if (_gameController.gameState == GameState.playing)
                        Positioned(
                          top: 8,
                          left: 12,
                          right: 12,
                          child: _buildGameHUD(),
                        ),

                      if (_gameController.gameState == GameState.ready)
                        _buildStartScreen(),

                      if (_gameController.gameState == GameState.paused)
                        _buildPauseScreen(),

                      if (_gameController.gameState == GameState.gameOver)
                        _buildGameOverScreen(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建游戏HUD（抬头显示）。
  Widget _buildGameHUD() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHUDItem(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFFFD54F),
          value: '${_gameController.player?.score ?? 0}',
        ),
        Row(
          children: [
            if (_gameController.player?.hasShield == true)
              _buildHUDItem(
                icon: Icons.shield_rounded,
                iconColor: const Color(0xFF4FC3F7),
                value: '${(_gameController.player!.shieldTime / 1000).toStringAsFixed(1)}s',
              ),
            if (_gameController.player != null &&
                _gameController.player!.fireLevel > 1)
              _buildHUDItem(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFFF8A65),
                value: 'Lv${_gameController.player!.fireLevel}',
              ),
            _buildLivesIndicator(),
          ],
        ),
        GestureDetector(
          onTap: _gameController.pauseGame,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.pause_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建HUD项。
  Widget _buildHUDItem({
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建生命值指示器。
  Widget _buildLivesIndicator() {
    final lives = _gameController.player?.lives ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Icon(
            index < lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: index < lives ? const Color(0xFFEF5350) : Colors.white.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
      ),
    );
  }

  /// 构建开始界面。
  Widget _buildStartScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0A0E2A).withValues(alpha: 0.95),
                const Color(0xFF101540).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4FC3F7).withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _titleAnimController,
                builder: (context, child) {
                  final glow = 0.5 + 0.5 * _titleAnimController.value;
                  return Column(
                    children: [
                      Text(
                        '✈ 飞机大战 ✈',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA), Color(0xFF4FC3F7)],
                            ).createShader(Rect.fromLTWH(0, 0, 250, 50)),
                          shadows: [
                            Shadow(
                              color: const Color(0xFF4FC3F7).withValues(alpha: glow * 0.6),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PLANE WAR',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 6,
                          color: const Color(0xFF81D4FA).withValues(alpha: 0.6),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '选择难度',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDifficultyChip('简单', GameDifficulty.easy, const Color(0xFF66BB6A)),
                        const SizedBox(width: 10),
                        _buildDifficultyChip('普通', GameDifficulty.normal, const Color(0xFF42A5F5)),
                        const SizedBox(width: 10),
                        _buildDifficultyChip('困难', GameDifficulty.hard, const Color(0xFFEF5350)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildGlowButton(
                text: '开始游戏',
                onTap: _gameController.startGame,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0288D1), Color(0xFF4FC3F7)],
                ),
                glowColor: const Color(0xFF4FC3F7),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildTipRow(Icons.touch_app_rounded, '拖动屏幕控制飞机'),
                    const SizedBox(height: 6),
                    _buildTipRow(Icons.auto_fix_high_rounded, '收集道具增强火力'),
                    const SizedBox(height: 6),
                    _buildTipRow(Icons.shield_rounded, '护盾可抵挡一次伤害'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建提示行。
  Widget _buildTipRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF81D4FA).withValues(alpha: 0.6), size: 14),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 构建难度选择芯片。
  Widget _buildDifficultyChip(String label, GameDifficulty diff, Color color) {
    final isSelected = _gameController.difficulty == diff;
    return GestureDetector(
      onTap: () => _gameController.setDifficulty(diff),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8)]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 构建发光按钮。
  Widget _buildGlowButton({
    required String text,
    required VoidCallback onTap,
    required LinearGradient gradient,
    required Color glowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  /// 构建暂停界面。
  Widget _buildPauseScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0E2A).withValues(alpha: 0.95),
              const Color(0xFF101540).withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.pause_circle_rounded,
              color: Color(0xFF4FC3F7),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              '游戏暂停',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '得分: ${_gameController.player?.score ?? 0}',
              style: TextStyle(
                color: const Color(0xFFFFD54F),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _buildGlowButton(
              text: '继续游戏',
              onTap: _gameController.resumeGame,
              gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
              glowColor: const Color(0xFF66BB6A),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                _gameController.initGame(
                  _gameController.screenWidth,
                  _gameController.screenHeight,
                );
                _gameController.startGame();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  '重新开始',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建游戏结束界面。
  Widget _buildGameOverScreen() {
    final isNewHighScore = (_gameController.player?.score ?? 0) >= _gameController.highScore &&
        _gameController.highScore > 0;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A0A0A).withValues(alpha: 0.95),
              const Color(0xFF2A0A0A).withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFEF5350).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF5350).withValues(alpha: 0.1),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.flight_land_rounded,
              color: Color(0xFFEF5350),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              '游戏结束',
              style: TextStyle(
                color: Color(0xFFEF5350),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${_gameController.player?.score ?? 0}',
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '最终得分',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  if (isNewHighScore) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD54F), size: 16),
                          SizedBox(width: 4),
                          Text(
                            '新纪录!',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '最高分: ${_gameController.highScore}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildGlowButton(
              text: '再来一局',
              onTap: _gameController.startGame,
              gradient: const LinearGradient(
                colors: [Color(0xFF0288D1), Color(0xFF4FC3F7)],
              ),
              glowColor: const Color(0xFF4FC3F7),
            ),
          ],
        ),
      ),
    );
  }
}
