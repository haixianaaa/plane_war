import 'package:flutter/material.dart';

/// 游戏对象基类。
///
/// 所有游戏对象（玩家、敌机、子弹）的基类，包含位置和尺寸信息。
class GameObject {
  /// 对象在屏幕上的 X 坐标
  double x;

  /// 对象在屏幕上的 Y 坐标
  double y;

  /// 对象的宽度
  double width;

  /// 对象的高度
  double height;

  /// 创建游戏对象实例。
  GameObject({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  /// 获取对象的矩形区域，用于碰撞检测。
  Rect get rect => Rect.fromLTWH(x, y, width, height);

  /// 检查是否与另一个对象碰撞。
  bool collidesWith(GameObject other) {
    return rect.overlaps(other.rect);
  }
}

/// 玩家飞机类。
class Player extends GameObject {
  /// 玩家生命值
  int lives;

  /// 玩家得分
  int score;

  /// 火力等级（1-3）
  int fireLevel;

  /// 护盾是否激活
  bool hasShield;

  /// 护盾剩余时间（毫秒）
  int shieldTime;

  /// 无敌时间（毫秒）
  int invincibleTime;

  /// 创建玩家飞机实例。
  Player({
    required super.x,
    required super.y,
    super.width = 48,
    super.height = 56,
    this.lives = 3,
    this.score = 0,
    this.fireLevel = 1,
    this.hasShield = false,
    this.shieldTime = 0,
    this.invincibleTime = 0,
  });

  /// 移动玩家飞机。
  void move(double dx, double dy, double screenWidth, double screenHeight) {
    x = (x + dx).clamp(0, screenWidth - width);
    y = (y + dy).clamp(0, screenHeight - height);
  }
}

/// 敌机类。
class Enemy extends GameObject {
  /// 敌机类型（1: 小型, 2: 中型, 3: 大型/Boss）
  final int type;

  /// 敌机生命值
  int health;

  /// 敌机移动速度
  final double speed;

  /// 敌机得分值
  final int scoreValue;

  /// 敌机横向移动偏移（用于蛇形移动）
  double swayOffset;

  /// 敌机横向移动方向
  int swayDirection;

  /// 创建敌机实例。
  Enemy({
    required super.x,
    required super.y,
    required this.type,
  })  : speed = getSpeedByType(type),
        health = getHealthByType(type),
        scoreValue = getScoreByType(type),
        swayOffset = 0,
        swayDirection = 1,
        super(
          width: getSizeByType(type),
          height: getSizeByType(type) * (type == 3 ? 1.2 : 1.0),
        );

  /// 根据类型获取敌机尺寸。
  static double getSizeByType(int type) {
    switch (type) {
      case 1:
        return 36;
      case 2:
        return 50;
      case 3:
        return 68;
      default:
        return 36;
    }
  }

  /// 根据类型获取敌机速度。
  static double getSpeedByType(int type) {
    switch (type) {
      case 1:
        return 3.5;
      case 2:
        return 2.5;
      case 3:
        return 1.8;
      default:
        return 3.5;
    }
  }

  /// 根据类型获取敌机生命值。
  static int getHealthByType(int type) {
    switch (type) {
      case 1:
        return 1;
      case 2:
        return 3;
      case 3:
        return 6;
      default:
        return 1;
    }
  }

  /// 根据类型获取敌机得分值。
  static int getScoreByType(int type) {
    switch (type) {
      case 1:
        return 10;
      case 2:
        return 25;
      case 3:
        return 50;
      default:
        return 10;
    }
  }

  /// 更新敌机位置。
  void update() {
    y += speed;

    if (type == 2) {
      swayOffset += 0.5 * swayDirection;
      if (swayOffset.abs() > 30) {
        swayDirection *= -1;
      }
      x += swayDirection * 0.8;
    }
  }

  /// 检查敌机是否超出屏幕。
  bool isOffScreen(double screenHeight) {
    return y > screenHeight;
  }
}

/// 子弹类。
class Bullet extends GameObject {
  /// 子弹移动速度
  final double speed;

  /// 子弹是否为玩家的
  final bool isPlayerBullet;

  /// 子弹伤害值
  final int damage;

  /// 创建子弹实例。
  Bullet({
    required super.x,
    required super.y,
    this.isPlayerBullet = true,
    super.width = 5,
    super.height = 14,
    this.speed = 10,
    this.damage = 1,
  });

  /// 更新子弹位置。
  void update() {
    if (isPlayerBullet) {
      y -= speed;
    } else {
      y += speed;
    }
  }

  /// 检查子弹是否超出屏幕。
  bool isOffScreen(double screenHeight) {
    return y < -height || y > screenHeight;
  }
}

/// 爆炸效果类。
class Explosion extends GameObject {
  /// 爆炸动画当前帧（0-1）
  double progress;

  /// 爆炸动画持续时间（毫秒）
  final int duration;

  /// 爆炸类型（1: 普通爆炸, 2: 大型爆炸）
  final int explosionType;

  /// 创建爆炸效果实例。
  Explosion({
    required super.x,
    required super.y,
    super.width = 60,
    super.height = 60,
    this.progress = 0,
    this.duration = 400,
    this.explosionType = 1,
  });

  /// 更新爆炸动画进度。
  void update(int deltaTime) {
    progress += deltaTime / duration;
  }

  /// 检查爆炸动画是否完成。
  bool isFinished() {
    return progress >= 1;
  }
}

/// 道具类。
class PowerUp extends GameObject {
  /// 道具类型（1: 生命值, 2: 增强火力, 3: 护盾）
  final int type;

  /// 道具移动速度
  final double speed;

  /// 道具动画帧计数
  double animFrame;

  /// 创建道具实例。
  PowerUp({
    required super.x,
    required super.y,
    required this.type,
    this.speed = 2,
    this.animFrame = 0,
  }) : super(width: 28, height: 28);

  /// 更新道具位置。
  void update() {
    y += speed;
    animFrame += 0.05;
  }

  /// 检查道具是否超出屏幕。
  bool isOffScreen(double screenHeight) {
    return y > screenHeight;
  }
}

/// 背景星星类。
class Star {
  /// 星星 X 坐标
  double x;

  /// 星星 Y 坐标
  double y;

  /// 星星大小
  double size;

  /// 星星速度
  double speed;

  /// 星星亮度
  double brightness;

  /// 创建星星实例。
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    this.brightness = 1.0,
  });

  /// 更新星星位置。
  void update(double screenHeight) {
    y += speed;
    if (y > screenHeight) {
      y = -5;
    }
  }
}

/// 游戏状态枚举。
enum GameState {
  /// 游戏准备中
  ready,

  /// 游戏进行中
  playing,

  /// 游戏暂停
  paused,

  /// 游戏结束
  gameOver,
}

/// 游戏难度枚举。
enum GameDifficulty {
  /// 简单
  easy,

  /// 普通
  normal,

  /// 困难
  hard,
}
