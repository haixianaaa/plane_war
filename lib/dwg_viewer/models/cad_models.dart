import 'dart:math';
import 'package:flutter/material.dart';

/// CAD 实体类型枚举。
///
/// 定义支持的 CAD 图形元素类型。
enum CADEntityType {
  /// 直线
  line,

  /// 圆
  circle,

  /// 圆弧
  arc,

  /// 多段线
  polyline,

  /// 文字
  text,

  /// 尺寸标注
  dimension,

  /// 块引用
  blockReference,
}

/// CAD 图层信息。
///
/// 存储图层的属性，包括名称、颜色、可见性等。
class CADLayer {
  /// 图层名称
  final String name;

  /// 图层颜色
  final Color color;

  /// 线宽
  final double lineWidth;

  /// 是否可见
  bool isVisible;

  /// 是否锁定
  final bool isLocked;

  /// 创建图层实例。
  ///
  /// [name] 图层名称
  /// [color] 图层颜色
  /// [lineWidth] 线宽
  /// [isVisible] 是否可见
  /// [isLocked] 是否锁定
  CADLayer({
    required this.name,
    this.color = Colors.black,
    this.lineWidth = 1.0,
    this.isVisible = true,
    this.isLocked = false,
  });
}

/// CAD 实体基类。
///
/// 所有 CAD 图形元素的基类，包含通用属性。
class CADEntity {
  /// 实体唯一标识符
  final String id;

  /// 实体类型
  final CADEntityType type;

  /// 所属图层
  final String layerName;

  /// 颜色（覆盖图层颜色）
  final Color? color;

  /// 线宽（覆盖图层线宽）
  final double? lineWidth;

  /// 创建实体实例。
  CADEntity({
    required this.id,
    required this.type,
    required this.layerName,
    this.color,
    this.lineWidth,
  });
}

/// 直线实体。
class CADLine extends CADEntity {
  /// 起点坐标
  final Point<double> start;

  /// 终点坐标
  final Point<double> end;

  /// 创建直线实例。
  CADLine({
    required super.id,
    required super.layerName,
    required this.start,
    required this.end,
    super.color,
    super.lineWidth,
  }) : super(type: CADEntityType.line);
}

/// 圆实体。
class CADCircle extends CADEntity {
  /// 圆心坐标
  final Point<double> center;

  /// 半径
  final double radius;

  /// 创建圆实例。
  CADCircle({
    required super.id,
    required super.layerName,
    required this.center,
    required this.radius,
    super.color,
    super.lineWidth,
  }) : super(type: CADEntityType.circle);
}

/// 圆弧实体。
class CADArc extends CADEntity {
  /// 圆心坐标
  final Point<double> center;

  /// 半径
  final double radius;

  /// 起始角度（弧度）
  final double startAngle;

  /// 结束角度（弧度）
  final double endAngle;

  /// 创建圆弧实例。
  CADArc({
    required super.id,
    required super.layerName,
    required this.center,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    super.color,
    super.lineWidth,
  }) : super(type: CADEntityType.arc);
}

/// 多段线实体。
class CADPolyline extends CADEntity {
  /// 顶点坐标列表
  final List<Point<double>> points;

  /// 是否闭合
  final bool isClosed;

  /// 创建多段线实例。
  CADPolyline({
    required super.id,
    required super.layerName,
    required this.points,
    this.isClosed = false,
    super.color,
    super.lineWidth,
  }) : super(type: CADEntityType.polyline);
}

/// 文字实体。
class CADText extends CADEntity {
  /// 文本位置
  final Point<double> position;

  /// 文本内容
  final String content;

  /// 字体高度
  final double height;

  /// 旋转角度（弧度）
  final double rotation;

  /// 创建文字实例。
  CADText({
    required super.id,
    required super.layerName,
    required this.position,
    required this.content,
    this.height = 2.5,
    this.rotation = 0,
    super.color,
    super.lineWidth,
  }) : super(type: CADEntityType.text);
}

/// CAD 文档类。
///
/// 表示一个完整的 CAD/DWG 文档，包含所有实体和元数据。
class CADDocument {
  /// 文档标题
  final String title;

  /// 作者
  final String? author;

  /// 创建日期
  final DateTime? createdDate;

  /// 修改日期
  final DateTime? modifiedDate;

  /// 图层列表
  final List<CADLayer> layers;

  /// 实体列表
  final List<CADEntity> entities;

  /// 文档边界（最小外接矩形）
  Rect? bounds;

  /// 单位（毫米、厘米、米等）
  final String unit;

  /// 创建文档实例。
  CADDocument({
    this.title = '未命名',
    this.author,
    this.createdDate,
    this.modifiedDate,
    List<CADLayer>? layers,
    List<CADEntity>? entities,
    this.unit = 'mm',
  })  : layers = layers ?? [
          CADLayer(name: '0', color: Colors.black, lineWidth: 1.0),
        ],
        entities = entities ?? [];

  /// 计算文档边界。
  void calculateBounds() {
    if (entities.isEmpty) {
      bounds = null;
      return;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final entity in entities) {
      final entityBounds = _getEntityBounds(entity);

      if (entityBounds != null) {
        minX = min(minX, entityBounds.left);
        minY = min(minY, entityBounds.top);
        maxX = max(maxX, entityBounds.right);
        maxY = max(maxY, entityBounds.bottom);
      }
    }

    if (minX != double.infinity && minY != double.infinity) {
      bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
    } else {
      bounds = null;
    }
  }

  /// 获取实体的边界矩形。
  Rect? _getEntityBounds(CADEntity entity) {
    switch (entity.type) {
      case CADEntityType.line:
        final line = entity as CADLine;
        return Rect.fromPoints(Offset(line.start.x, line.start.y), Offset(line.end.x, line.end.y));

      case CADEntityType.circle:
        final circle = entity as CADCircle;
        return Rect.fromCircle(
          center: Offset(circle.center.x, circle.center.y),
          radius: circle.radius,
        );

      case CADEntityType.arc:
        final arc = entity as CADArc;
        return Rect.fromCircle(
          center: Offset(arc.center.x, arc.center.y),
          radius: arc.radius,
        );

      case CADEntityType.polyline:
        final polyline = entity as CADPolyline;
        if (polyline.points.isEmpty) return null;

        double minX = polyline.points.first.x;
        double minY = polyline.points.first.y;
        double maxX = minX;
        double maxY = minY;

        for (final point in polyline.points) {
          minX = min(minX, point.x);
          minY = min(minY, point.y);
          maxX = max(maxX, point.x);
          maxY = max(maxY, point.y);
        }

        return Rect.fromLTRB(minX, minY, maxX, maxY);

      case CADEntityType.text:
        final text = entity as CADText;
        return Rect.fromCenter(
          center: Offset(text.position.x, text.position.y),
          width: text.content.length * text.height * 0.6,
          height: text.height,
        );

      default:
        return null;
    }
  }

  /// 获取可见的实体列表。
  List<CADEntity> getVisibleEntities() {
    final visibleLayers = <String>{};

    for (final layer in layers) {
      if (layer.isVisible) {
        visibleLayers.add(layer.name);
      }
    }

    return entities.where((e) => visibleLayers.contains(e.layerName)).toList();
  }
}
