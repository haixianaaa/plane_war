# 飞机大战

一款使用 Flutter 开发的经典飞机射击游戏。

## 游戏特性

- 流畅的触摸控制玩家飞机
- 多种不同行为的敌机类型
- 道具系统（护盾、速射、三连发）
- 渐变背景和粒子特效
- 分数追踪和游戏状态管理
- 适配各种屏幕尺寸的响应式设计

## 开始使用

### 环境要求

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK（用于 Android 构建）

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/haixianaaa/plane_war.git
cd plane_war
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

### 打包 APK

使用内置的打包脚本：

```powershell
.\build_apk.ps1 -AppName "我的飞机大战"
```

或手动构建：

```bash
flutter build apk --release
```

APK 文件将生成在 `build/app/outputs/flutter-apk/app-release.apk`。

## 项目结构

```
lib/
├── game/
│   ├── game_controller.dart    # 游戏状态管理
│   ├── models/
│   │   └── game_models.dart    # 游戏实体（玩家、敌机、子弹等）
│   └── widgets/
│       └── game_canvas.dart    # 游戏渲染组件
├── pages/
│   └── game_page.dart          # 主游戏界面
└── main.dart                   # 应用入口
```

## 游戏操作

- **移动**：触摸并拖动来移动玩家飞机
- **射击**：自动开火
- **道具**：收集道具获得能力
  - 护盾：临时无敌
  - 速射：提高射速
  - 三连发：同时发射三颗子弹

## 技术说明

### Windows 构建修复

本项目包含针对 Windows 平台 Ninja `GetOverlappedResult` 错误的解决方案，通过使用 Unix Makefiles 替代 Ninja 进行原生构建。详见 `android/app/build.gradle.kts`。

## 依赖

- `flutter` - UI 框架
- `cupertino_icons` - iOS 风格图标

## 许可证

本项目采用 [MIT 许可证](LICENSE) 开源。

## 作者

- GitHub: [@haixianaaa](https://github.com/haixianaaa)

## 致谢

- 使用 [Flutter](https://flutter.dev/) 构建
- 灵感来源于经典街机射击游戏
