import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/game/models/game_models.dart';

/// 游戏控制器。
///
/// 管理游戏状态、游戏循环、碰撞检测等核心逻辑。
/// 使用 ChangeNotifier 实现状态管理。
class GameController extends ChangeNotifier {
  /// 玩家飞机实例
  Player? player;

  /// 敌机列表
  final List<Enemy> enemies = [];

  /// 玩家子弹列表
  final List<Bullet> playerBullets = [];

  /// 敌机子弹列表
  final List<Bullet> enemyBullets = [];

  /// 爆炸效果列表
  final List<Explosion> explosions = [];

  /// 道具列表
  final List<PowerUp> powerUps = [];

  /// 背景星星列表
  final List<Star> stars = [];

  /// 当前游戏状态
  GameState gameState = GameState.ready;

  /// 游戏难度
  GameDifficulty difficulty = GameDifficulty.normal;

  /// 游戏帧率
  final int fps;

  /// 帧间隔时间（毫秒）
  final int frameInterval;

  /// 游戏循环定时器
  Timer? _gameTimer;

  /// 上一次更新时间
  DateTime? _lastUpdateTime;

  /// 屏幕宽度
  double screenWidth = 0;

  /// 屏幕高度
  double screenHeight = 0;

  /// 敌机生成计数器
  int _enemySpawnCounter = 0;

  /// 敌机生成间隔（帧数）
  int _enemySpawnInterval = 60;

  /// 玩家射击冷却计数器
  int _playerShootCooldown = 0;

  /// 玩家射击间隔（帧数）
  int _playerShootInterval = 10;

  /// 道具生成计数器
  int _powerUpSpawnCounter = 0;

  /// 道具生成间隔（帧数）
  final int _powerUpSpawnInterval = 300;

  /// 随机数生成器
  final Random _random = Random();

  /// 最高分
  int highScore = 0;

  /// 创建游戏控制器实例。
  GameController({this.fps = 60}) : frameInterval = 1000 ~/ fps;

  /// 初始化游戏。
  void initGame(double width, double height) {
    screenWidth = width;
    screenHeight = height;

    player = Player(
      x: width / 2 - 24,
      y: height - 130,
      width: 48,
      height: 56,
      lives: 3,
      score: 0,
      fireLevel: 1,
      hasShield: false,
      shieldTime: 0,
      invincibleTime: 0,
    );

    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    explosions.clear();
    powerUps.clear();

    _enemySpawnCounter = 0;
    _playerShootCooldown = 0;
    _powerUpSpawnCounter = 0;

    _initStars();
    _updateDifficultySettings();

    gameState = GameState.ready;
    notifyListeners();
  }

  /// 初始化背景星星。
  void _initStars() {
    stars.clear();
    for (int i = 0; i < 80; i++) {
      stars.add(Star(
        x: _random.nextDouble() * screenWidth,
        y: _random.nextDouble() * screenHeight,
        size: _random.nextDouble() * 1.8 + 0.3,
        speed: _random.nextDouble() * 1.5 + 0.3,
        brightness: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  /// 根据难度更新游戏设置。
  void _updateDifficultySettings() {
    switch (difficulty) {
      case GameDifficulty.easy:
        _enemySpawnInterval = 90;
        _playerShootInterval = 8;
        break;
      case GameDifficulty.normal:
        _enemySpawnInterval = 60;
        _playerShootInterval = 10;
        break;
      case GameDifficulty.hard:
        _enemySpawnInterval = 40;
        _playerShootInterval = 12;
        break;
    }
  }

  /// 开始游戏。
  void startGame() {
    if (gameState == GameState.ready || gameState == GameState.gameOver) {
      initGame(screenWidth, screenHeight);
      gameState = GameState.playing;
      _startGameLoop();
      notifyListeners();
    }
  }

  /// 暂停游戏。
  void pauseGame() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
      _stopGameLoop();
      notifyListeners();
    }
  }

  /// 恢复游戏。
  void resumeGame() {
    if (gameState == GameState.paused) {
      gameState = GameState.playing;
      _startGameLoop();
      notifyListeners();
    }
  }

  /// 结束游戏。
  void _endGame() {
    gameState = GameState.gameOver;
    _stopGameLoop();

    if (player != null && player!.score > highScore) {
      highScore = player!.score;
    }

    notifyListeners();
  }

  /// 开始游戏循环。
  void _startGameLoop() {
    _lastUpdateTime = DateTime.now();
    _gameTimer = Timer.periodic(
      Duration(milliseconds: frameInterval),
      (_) => _gameLoop(),
    );
  }

  /// 停止游戏循环。
  void _stopGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  /// 游戏主循环。
  void _gameLoop() {
    if (gameState != GameState.playing || player == null) return;

    final now = DateTime.now();
    final deltaTime = now.difference(_lastUpdateTime!).inMilliseconds;
    _lastUpdateTime = now;

    _updateStars();
    _updatePlayer(deltaTime);
    _updateEnemies();
    _updateBullets();
    _updateExplosions(deltaTime);
    _updatePowerUps();

    _spawnEnemies();
    _spawnPowerUps();

    _playerAutoShoot();

    _checkCollisions();

    notifyListeners();
  }

  /// 更新背景星星。
  void _updateStars() {
    for (final star in stars) {
      star.update(screenHeight);
      star.brightness += 0.02;
    }
  }

  /// 更新玩家状态。
  void _updatePlayer(int deltaTime) {
    if (player!.invincibleTime > 0) {
      player!.invincibleTime -= deltaTime;
      if (player!.invincibleTime < 0) player!.invincibleTime = 0;
    }

    if (player!.hasShield) {
      player!.shieldTime -= deltaTime;
      if (player!.shieldTime <= 0) {
        player!.hasShield = false;
        player!.shieldTime = 0;
      }
    }
  }

  /// 更新敌机位置。
  void _updateEnemies() {
    enemies.removeWhere((enemy) => enemy.isOffScreen(screenHeight));

    for (final enemy in enemies) {
      enemy.update();

      if (enemy.type >= 2 && _random.nextDouble() < 0.008) {
        _enemyShoot(enemy);
      } else if (enemy.type == 1 && _random.nextDouble() < 0.003) {
        _enemyShoot(enemy);
      }
    }
  }

  /// 更新子弹位置。
  void _updateBullets() {
    playerBullets.removeWhere((bullet) => bullet.isOffScreen(screenHeight));
    enemyBullets.removeWhere((bullet) => bullet.isOffScreen(screenHeight));

    for (final bullet in playerBullets) {
      bullet.update();
    }
    for (final bullet in enemyBullets) {
      bullet.update();
    }
  }

  /// 更新爆炸效果。
  void _updateExplosions(int deltaTime) {
    explosions.removeWhere((explosion) => explosion.isFinished());

    for (final explosion in explosions) {
      explosion.update(deltaTime);
    }
  }

  /// 更新道具位置。
  void _updatePowerUps() {
    powerUps.removeWhere((powerUp) => powerUp.isOffScreen(screenHeight));

    for (final powerUp in powerUps) {
      powerUp.update();
    }
  }

  /// 生成敌机。
  void _spawnEnemies() {
    _enemySpawnCounter++;

    if (_enemySpawnCounter >= _enemySpawnInterval) {
      _enemySpawnCounter = 0;

      int type;
      final roll = _random.nextDouble();
      if (roll < 0.55) {
        type = 1;
      } else if (roll < 0.85) {
        type = 2;
      } else {
        type = 3;
      }

      final enemyWidth = Enemy.getSizeByType(type);
      final x = _random.nextDouble() * (screenWidth - enemyWidth);

      enemies.add(Enemy(
        x: x,
        y: -enemyWidth,
        type: type,
      ));
    }
  }

  /// 生成道具。
  void _spawnPowerUps() {
    _powerUpSpawnCounter++;

    if (_powerUpSpawnCounter >= _powerUpSpawnInterval) {
      _powerUpSpawnCounter = 0;

      final type = _random.nextInt(3) + 1;

      final x = _random.nextDouble() * (screenWidth - 28);

      powerUps.add(PowerUp(
        x: x,
        y: -28,
        type: type,
      ));
    }
  }

  /// 玩家自动射击。
  void _playerAutoShoot() {
    if (_playerShootCooldown > 0) {
      _playerShootCooldown--;
      return;
    }

    _playerShootCooldown = _playerShootInterval;
    _playerShoot();
  }

  /// 玩家射击。
  void _playerShoot() {
    if (player == null) return;

    final cx = player!.x + player!.width / 2;
    final bulletY = player!.y;

    if (player!.fireLevel == 1) {
      playerBullets.add(Bullet(
        x: cx - 2.5,
        y: bulletY,
        isPlayerBullet: true,
      ));
    } else if (player!.fireLevel == 2) {
      playerBullets.add(Bullet(
        x: cx - 8,
        y: bulletY,
        isPlayerBullet: true,
      ));
      playerBullets.add(Bullet(
        x: cx + 3,
        y: bulletY,
        isPlayerBullet: true,
      ));
    } else {
      playerBullets.add(Bullet(
        x: cx - 2.5,
        y: bulletY - 5,
        isPlayerBullet: true,
        damage: 1,
      ));
      playerBullets.add(Bullet(
        x: cx - 12,
        y: bulletY + 5,
        isPlayerBullet: true,
      ));
      playerBullets.add(Bullet(
        x: cx + 7,
        y: bulletY + 5,
        isPlayerBullet: true,
      ));
    }
  }

  /// 敌机射击。
  void _enemyShoot(Enemy enemy) {
    enemyBullets.add(Bullet(
      x: enemy.x + enemy.width / 2 - 3,
      y: enemy.y + enemy.height,
      isPlayerBullet: false,
      speed: 5,
      width: 6,
      height: 10,
    ));
  }

  /// 碰撞检测。
  void _checkCollisions() {
    if (player == null) return;

    for (int i = playerBullets.length - 1; i >= 0; i--) {
      final bullet = playerBullets[i];

      for (int j = enemies.length - 1; j >= 0; j--) {
        final enemy = enemies[j];

        if (bullet.collidesWith(enemy)) {
          playerBullets.removeAt(i);

          enemy.health -= bullet.damage;

          if (enemy.health <= 0) {
            explosions.add(Explosion(
              x: enemy.x + enemy.width / 2 - 30,
              y: enemy.y + enemy.height / 2 - 30,
              explosionType: enemy.type >= 2 ? 2 : 1,
              width: enemy.type == 3 ? 80 : 60,
              height: enemy.type == 3 ? 80 : 60,
            ));

            player!.score += enemy.scoreValue;

            if (enemy.type == 3) {
              player!.score += 10;
            }

            enemies.removeAt(j);
          }

          break;
        }
      }
    }

    if (player!.invincibleTime > 0) return;

    for (int i = enemyBullets.length - 1; i >= 0; i--) {
      final bullet = enemyBullets[i];

      if (bullet.collidesWith(player!)) {
        enemyBullets.removeAt(i);

        if (player!.hasShield) {
          player!.hasShield = false;
          player!.shieldTime = 0;
        } else {
          player!.lives--;
          player!.invincibleTime = 1500;

          if (player!.lives <= 0) {
            explosions.add(Explosion(
              x: player!.x + player!.width / 2 - 40,
              y: player!.y + player!.height / 2 - 40,
              width: 80,
              height: 80,
              explosionType: 2,
            ));
            _endGame();
            return;
          }
        }
      }
    }

    for (int i = enemies.length - 1; i >= 0; i--) {
      final enemy = enemies[i];

      if (enemy.collidesWith(player!)) {
        explosions.add(Explosion(
          x: enemy.x + enemy.width / 2 - 30,
          y: enemy.y + enemy.height / 2 - 30,
          explosionType: 2,
        ));

        enemies.removeAt(i);

        if (player!.hasShield) {
          player!.hasShield = false;
          player!.shieldTime = 0;
        } else {
          player!.lives--;
          player!.invincibleTime = 1500;

          if (player!.lives <= 0) {
            explosions.add(Explosion(
              x: player!.x + player!.width / 2 - 40,
              y: player!.y + player!.height / 2 - 40,
              width: 80,
              height: 80,
              explosionType: 2,
            ));
            _endGame();
            return;
          }
        }
      }
    }

    for (int i = powerUps.length - 1; i >= 0; i--) {
      final powerUp = powerUps[i];

      if (powerUp.collidesWith(player!)) {
        if (powerUp.type == 1) {
          player!.lives = (player!.lives + 1).clamp(0, 5);
        } else if (powerUp.type == 2) {
          player!.fireLevel = (player!.fireLevel + 1).clamp(1, 3);
        } else if (powerUp.type == 3) {
          player!.hasShield = true;
          player!.shieldTime = 8000;
        }

        powerUps.removeAt(i);
      }
    }
  }

  /// 移动玩家飞机。
  void movePlayer(double dx, double dy) {
    if (player != null && gameState == GameState.playing) {
      player!.move(dx, dy, screenWidth, screenHeight);
      notifyListeners();
    }
  }

  /// 设置玩家飞机位置。
  void setPlayerPosition(double x, double y) {
    if (player != null && gameState == GameState.playing) {
      player!.x = (x - player!.width / 2).clamp(0, screenWidth - player!.width);
      player!.y = (y - player!.height / 2).clamp(0, screenHeight - player!.height);
      notifyListeners();
    }
  }

  /// 设置游戏难度。
  void setDifficulty(GameDifficulty newDifficulty) {
    difficulty = newDifficulty;
    _updateDifficultySettings();
    notifyListeners();
  }

  /// 释放资源。
  @override
  void dispose() {
    _stopGameLoop();
    super.dispose();
  }
}
