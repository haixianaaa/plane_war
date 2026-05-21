/// 创作者卡片数据模型。
///
/// 用于在发现页面展示创作者信息卡片。
/// 包含创作者名称、作者、标签和头像图片 URL。
class CreatorCardData {
  /// 创建创作者卡片数据实例。
  ///
  /// [name] 创作者名称
  /// [author] 作者名称
  /// [tag] 分类标签
  /// [imageUrl] 头像图片 URL
  const CreatorCardData({
    required this.name,
    required this.author,
    required this.tag,
    required this.imageUrl,
  });

  /// 创作者名称
  /// 显示在卡片标题位置
  final String name;

  /// 作者名称
  /// 显示在卡片副标题位置
  final String author;

  /// 分类标签
  /// 用于筛选和分类显示
  final String tag;

  /// 头像图片 URL
  /// 用于显示创作者头像
  final String imageUrl;
}
