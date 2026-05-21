import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/game/models/game_models.dart';

/// 游戏画布组件。
///
/// 负责渲染所有游戏对象，使用精美渐变和光效绘制飞机、敌机、子弹等。
class GameCanvas extends StatelessWidget {
  /// 玩家飞机实例
  final Player? player;

  /// 敌机列表
  final List<Enemy> enemies;

  /// 玩家子弹列表
  final List<Bullet> playerBullets;

  /// 敌机子弹列表
  final List<Bullet> enemyBullets;

  /// 爆炸效果列表
  final List<Explosion> explosions;

  /// 道具列表
  final List<PowerUp> powerUps;

  /// 背景星星列表
  final List<Star> stars;

  /// 创建游戏画布实例。
  const GameCanvas({
    super.key,
    required this.player,
    required this.enemies,
    required this.playerBullets,
    required this.enemyBullets,
    required this.explosions,
    required this.powerUps,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GamePainter(
        player: player,
        enemies: enemies,
        playerBullets: playerBullets,
        enemyBullets: enemyBullets,
        explosions: explosions,
        powerUps: powerUps,
        stars: stars,
      ),
      size: Size.infinite,
    );
  }
}

/// 游戏画布绘制器。
class _GamePainter extends CustomPainter {
  /// 玩家飞机实例
  final Player? player;

  /// 敌机列表
  final List<Enemy> enemies;

  /// 玩家子弹列表
  final List<Bullet> playerBullets;

  /// 敌机子弹列表
  final List<Bullet> enemyBullets;

  /// 爆炸效果列表
  final List<Explosion> explosions;

  /// 道具列表
  final List<PowerUp> powerUps;

  /// 背景星星列表
  final List<Star> stars;

  /// 创建绘制器实例。
  _GamePainter({
    required this.player,
    required this.enemies,
    required this.playerBullets,
    required this.enemyBullets,
    required this.explosions,
    required this.powerUps,
    required this.stars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawStars(canvas, size);

    for (final powerUp in powerUps) {
      _drawPowerUp(canvas, powerUp);
    }

    for (final bullet in playerBullets) {
      _drawPlayerBullet(canvas, bullet);
    }

    for (final bullet in enemyBullets) {
      _drawEnemyBullet(canvas, bullet);
    }

    for (final enemy in enemies) {
      _drawEnemy(canvas, enemy);
    }

    if (player != null) {
      _drawPlayer(canvas, player!);
    }

    for (final explosion in explosions) {
      _drawExplosion(canvas, explosion);
    }
  }

  /// 绘制深空背景渐变。
  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF020515),
          Color(0xFF0A0E2A),
          Color(0xFF101540),
          Color(0xFF0A0E2A),
          Color(0xFF020515),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.3, -0.2),
        radius: 0.8,
        colors: [
          const Color(0xFF1A0A3A).withValues(alpha: 0.3),
          const Color(0xFF0A0E2A).withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, nebulaPaint);
  }

  /// 绘制动态星空背景。
  void _drawStars(Canvas canvas, Size size) {
    for (final star in stars) {
      final flicker = 0.6 + 0.4 * sin(star.brightness * 10);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: flicker * 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(star.x, star.y), star.size, paint);

      if (star.size > 1.2) {
        final glowPaint = Paint()
          ..color = Colors.white.withValues(alpha: flicker * 0.15)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(star.x, star.y), star.size * 3, glowPaint);
      }
    }
  }

  /// 绘制玩家飞机（精美造型）。
  void _drawPlayer(Canvas canvas, Player player) {
    final cx = player.x + player.width / 2;
    final cy = player.y + player.height / 2;

    canvas.save();
    canvas.translate(cx, cy);

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4FC3F7),
          Color(0xFF0288D1),
          Color(0xFF01579B),
        ],
      ).createShader(Rect.fromLTWH(-player.width / 2, -player.height / 2, player.width, player.height))
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(0, -player.height / 2);
    bodyPath.quadraticBezierTo(-6, -player.height / 4, -8, 0);
    bodyPath.lineTo(-player.width / 2, player.height / 3);
    bodyPath.lineTo(-player.width / 2 + 4, player.height / 2);
    bodyPath.lineTo(-4, player.height / 4);
    bodyPath.lineTo(0, player.height / 2 - 2);
    bodyPath.lineTo(4, player.height / 4);
    bodyPath.lineTo(player.width / 2 - 4, player.height / 2);
    bodyPath.lineTo(player.width / 2, player.height / 3);
    bodyPath.lineTo(8, 0);
    bodyPath.quadraticBezierTo(6, -player.height / 4, 0, -player.height / 2);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    final edgePaint = Paint()
      ..color = const Color(0xFF81D4FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(bodyPath, edgePaint);

    final wingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0288D1), Color(0xFF01579B)],
      ).createShader(Rect.fromLTWH(-player.width / 2, 0, player.width, player.height / 2))
      ..style = PaintingStyle.fill;

    final leftWing = Path();
    leftWing.moveTo(-8, 2);
    leftWing.lineTo(-player.width / 2 - 4, player.height / 3 + 4);
    leftWing.lineTo(-player.width / 2, player.height / 3);
    leftWing.lineTo(-8, 6);
    leftWing.close();
    canvas.drawPath(leftWing, wingPaint);

    final rightWing = Path();
    rightWing.moveTo(8, 2);
    rightWing.lineTo(player.width / 2 + 4, player.height / 3 + 4);
    rightWing.lineTo(player.width / 2, player.height / 3);
    rightWing.lineTo(8, 6);
    rightWing.close();
    canvas.drawPath(rightWing, wingPaint);

    final cockpitPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7), Color(0xFF0288D1)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 7))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -player.height / 6), width: 8, height: 12),
      cockpitPaint,
    );

    final flameFlicker = 0.7 + 0.3 * sin(DateTime.now().millisecondsSinceEpoch / 50.0);
    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.9),
          const Color(0xFFFFF176).withValues(alpha: 0.8),
          const Color(0xFFFF9800).withValues(alpha: 0.6),
          const Color(0xFFFF5722).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(-5, player.height / 4, 10, 20 * flameFlicker))
      ..style = PaintingStyle.fill;

    final flamePath = Path();
    flamePath.moveTo(-4, player.height / 4);
    flamePath.quadraticBezierTo(-2, player.height / 4 + 8 * flameFlicker, 0, player.height / 4 + 18 * flameFlicker);
    flamePath.quadraticBezierTo(2, player.height / 4 + 8 * flameFlicker, 4, player.height / 4);
    flamePath.close();
    canvas.drawPath(flamePath, flamePaint);

    final flame2Path = Path();
    flame2Path.moveTo(-2, player.height / 4);
    flame2Path.quadraticBezierTo(-1, player.height / 4 + 5 * flameFlicker, 0, player.height / 4 + 12 * flameFlicker);
    flame2Path.quadraticBezierTo(1, player.height / 4 + 5 * flameFlicker, 2, player.height / 4);
    flame2Path.close();
    canvas.drawPath(flame2Path, Paint()..color = Colors.white.withValues(alpha: 0.5));

    if (player.hasShield) {
      final shieldPaint = Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(
        Offset.zero,
        player.width * 0.8,
        Paint()
          ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.08)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(Offset.zero, player.width * 0.8, shieldPaint);
    }

    if (player.invincibleTime > 0) {
      final blinkAlpha = (sin(DateTime.now().millisecondsSinceEpoch / 80.0) + 1) / 2 * 0.3;
      canvas.drawCircle(
        Offset.zero,
        player.width * 0.7,
        Paint()
          ..color = Colors.white.withValues(alpha: blinkAlpha)
          ..style = PaintingStyle.fill,
      );
    }

    canvas.restore();
  }

  /// 绘制敌机（精美造型）。
  void _drawEnemy(Canvas canvas, Enemy enemy) {
    final cx = enemy.x + enemy.width / 2;
    final cy = enemy.y + enemy.height / 2;

    canvas.save();
    canvas.translate(cx, cy);

    List<Color> bodyColors;
    List<Color> accentColors;
    switch (enemy.type) {
      case 1:
        bodyColors = [const Color(0xFFEF5350), const Color(0xFFC62828), const Color(0xFF8E0000)];
        accentColors = [const Color(0xFFFF8A80), const Color(0xFFEF5350)];
        break;
      case 2:
        bodyColors = [const Color(0xFFFFA726), const Color(0xFFE65100), const Color(0xFFBF360C)];
        accentColors = [const Color(0xFFFFCC80), const Color(0xFFFFA726)];
        break;
      case 3:
        bodyColors = [const Color(0xFFAB47BC), const Color(0xFF7B1FA2), const Color(0xFF4A0072)];
        accentColors = [const Color(0xFFCE93D8), const Color(0xFFAB47BC)];
        break;
      default:
        bodyColors = [const Color(0xFFEF5350), const Color(0xFFC62828), const Color(0xFF8E0000)];
        accentColors = [const Color(0xFFFF8A80), const Color(0xFFEF5350)];
    }

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: bodyColors,
      ).createShader(Rect.fromLTWH(-enemy.width / 2, -enemy.height / 2, enemy.width, enemy.height))
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(0, enemy.height / 2);
    bodyPath.quadraticBezierTo(-6, enemy.height / 4, -8, 0);
    bodyPath.lineTo(-enemy.width / 2, -enemy.height / 3);
    bodyPath.lineTo(-enemy.width / 2 + 4, -enemy.height / 2);
    bodyPath.lineTo(-4, -enemy.height / 4);
    bodyPath.lineTo(0, -enemy.height / 2);
    bodyPath.lineTo(4, -enemy.height / 4);
    bodyPath.lineTo(enemy.width / 2 - 4, -enemy.height / 2);
    bodyPath.lineTo(enemy.width / 2, -enemy.height / 3);
    bodyPath.lineTo(8, 0);
    bodyPath.quadraticBezierTo(6, enemy.height / 4, 0, enemy.height / 2);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    final edgePaint = Paint()
      ..color = accentColors[0]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(bodyPath, edgePaint);

    final cockpitPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFF9C4), ...accentColors.reversed],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 5))
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, enemy.height / 6), width: 7, height: 9),
      cockpitPaint,
    );

    if (enemy.type >= 2) {
      final hpRatio = enemy.health / Enemy.getHealthByType(enemy.type);
      if (hpRatio < 1.0) {
        final barWidth = enemy.width * 0.8;
        final barHeight = 3.0;
        final barY = -enemy.height / 2 - 8;

        canvas.drawRect(
          Rect.fromLTWH(-barWidth / 2, barY, barWidth, barHeight),
          Paint()..color = Colors.black.withValues(alpha: 0.5),
        );
        canvas.drawRect(
          Rect.fromLTWH(-barWidth / 2, barY, barWidth * hpRatio, barHeight),
          Paint()..color = hpRatio > 0.5 ? Colors.green : (hpRatio > 0.25 ? Colors.orange : Colors.red),
        );
      }
    }

    if (enemy.type == 3) {
      final glowPaint = Paint()
        ..color = const Color(0xFFAB47BC).withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, enemy.width * 0.7, glowPaint);
    }

    canvas.restore();
  }

  /// 绘制玩家子弹（光束效果）。
  void _drawPlayerBullet(Canvas canvas, Bullet bullet) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFF64FFDA), Color(0xFF00BCD4)],
      ).createShader(Rect.fromLTWH(bullet.x, bullet.y, bullet.width, bullet.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(bullet.x + bullet.width / 2, bullet.y);
    path.lineTo(bullet.x + bullet.width, bullet.y + bullet.height * 0.3);
    path.lineTo(bullet.x + bullet.width * 0.7, bullet.y + bullet.height);
    path.lineTo(bullet.x + bullet.width * 0.3, bullet.y + bullet.height);
    path.lineTo(bullet.x, bullet.y + bullet.height * 0.3);
    path.close();
    canvas.drawPath(path, paint);

    final glowPaint = Paint()
      ..color = const Color(0xFF64FFDA).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bullet.x + bullet.width / 2, bullet.y + bullet.height / 2),
        width: bullet.width * 3,
        height: bullet.height * 1.5,
      ),
      glowPaint,
    );
  }

  /// 绘制敌机子弹（红色光球）。
  void _drawEnemyBullet(Canvas canvas, Bullet bullet) {
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFFF5252), Color(0xFFB71C1C)],
      ).createShader(Rect.fromLTWH(bullet.x, bullet.y, bullet.width + 2, bullet.height + 2))
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(bullet.x, bullet.y, bullet.width, bullet.height),
      paint,
    );

    final glowPaint = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bullet.x + bullet.width / 2, bullet.y + bullet.height / 2),
        width: bullet.width * 3,
        height: bullet.height * 2,
      ),
      glowPaint,
    );
  }

  /// 绘制爆炸效果（多层粒子）。
  void _drawExplosion(Canvas canvas, Explosion explosion) {
    final progress = explosion.progress.clamp(0.0, 1.0);
    final opacity = 1.0 - progress;
    final centerX = explosion.x + explosion.width / 2;
    final centerY = explosion.y + explosion.height / 2;

    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * (1 - progress);
    canvas.drawCircle(
      Offset(centerX, centerY),
      explosion.width * 0.3 * (1 + progress * 2),
      ringPaint,
    );

    for (int i = 0; i < 3; i++) {
      final layerProgress = (progress - i * 0.1).clamp(0.0, 1.0);
      final layerOpacity = opacity * (1.0 - i * 0.25);
      final layerScale = 1.0 + layerProgress * (0.8 + i * 0.3);

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFFF176),
          const Color(0xFFFF5722),
          layerProgress,
        )!.withValues(alpha: layerOpacity * 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX, centerY),
        explosion.width / 2 * layerScale * 0.6,
        paint,
      );
    }

    final particleCount = explosion.explosionType == 2 ? 16 : 10;
    for (int i = 0; i < particleCount; i++) {
      final angle = i * 2 * pi / particleCount + progress * pi * 0.5;
      final distance = explosion.width * 0.5 * (0.5 + progress * 1.5);
      final px = centerX + distance * cos(angle);
      final py = centerY + distance * sin(angle);

      final particleColor = Color.lerp(
        const Color(0xFFFFEB3B),
        const Color(0xFFFF5722),
        progress,
      )!.withValues(alpha: opacity * 0.8);

      canvas.drawCircle(
        Offset(px, py),
        (3 - progress * 2).clamp(0.5, 3.0),
        Paint()..color = particleColor,
      );
    }

    if (progress < 0.3) {
      final flashOpacity = (1 - progress / 0.3) * 0.6;
      canvas.drawCircle(
        Offset(centerX, centerY),
        explosion.width * 0.2,
        Paint()..color = Colors.white.withValues(alpha: flashOpacity),
      );
    }
  }

  /// 绘制道具（发光效果）。
  void _drawPowerUp(Canvas canvas, PowerUp powerUp) {
    final cx = powerUp.x + powerUp.width / 2;
    final cy = powerUp.y + powerUp.height / 2;
    final pulse = 0.8 + 0.2 * sin(powerUp.animFrame * 6);

    Color mainColor;
    Color glowColor;
    switch (powerUp.type) {
      case 1:
        mainColor = const Color(0xFF66BB6A);
        glowColor = const Color(0xFF66BB6A);
        break;
      case 2:
        mainColor = const Color(0xFF42A5F5);
        glowColor = const Color(0xFF42A5F5);
        break;
      case 3:
        mainColor = const Color(0xFF4FC3F7);
        glowColor = const Color(0xFF4FC3F7);
        break;
      default:
        mainColor = const Color(0xFF66BB6A);
        glowColor = const Color(0xFF66BB6A);
    }

    canvas.drawCircle(
      Offset(cx, cy),
      powerUp.width * 0.7 * pulse,
      Paint()..color = glowColor.withValues(alpha: 0.15)..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      powerUp.width / 2 * pulse,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, mainColor],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: powerUp.width / 2 * pulse))
        ..style = PaintingStyle.fill,
    );

    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (powerUp.type == 1) {
      final heartPath = Path();
      final s = powerUp.width * 0.18;
      heartPath.moveTo(cx, cy + s * 0.4);
      heartPath.cubicTo(cx - s * 1.2, cy - s * 0.6, cx - s * 0.6, cy - s * 1.4, cx, cy - s * 0.6);
      heartPath.cubicTo(cx + s * 0.6, cy - s * 1.4, cx + s * 1.2, cy - s * 0.6, cx, cy + s * 0.4);
      canvas.drawPath(heartPath, iconPaint);
    } else if (powerUp.type == 2) {
      final starPath = Path();
      final outerR = powerUp.width * 0.22;
      final innerR = outerR * 0.45;
      for (int i = 0; i < 5; i++) {
        final outerAngle = i * 72 * pi / 180 - 90 * pi / 180;
        final innerAngle = (i * 72 + 36) * pi / 180 - 90 * pi / 180;
        if (i == 0) {
          starPath.moveTo(cx + outerR * cos(outerAngle), cy + outerR * sin(outerAngle));
        } else {
          starPath.lineTo(cx + outerR * cos(outerAngle), cy + outerR * sin(outerAngle));
        }
        starPath.lineTo(cx + innerR * cos(innerAngle), cy + innerR * sin(innerAngle));
      }
      starPath.close();
      canvas.drawPath(starPath, iconPaint);
    } else {
      canvas.drawCircle(
        Offset(cx, cy),
        powerUp.width * 0.2,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawCircle(
        Offset(cx, cy),
        powerUp.width * 0.08,
        iconPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GamePainter oldDelegate) {
    return true;
  }
}
