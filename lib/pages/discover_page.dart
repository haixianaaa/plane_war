import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/creator_card_data.dart';
import 'package:flutter_application_2/widgets/creator_card.dart';
import 'package:flutter_application_2/l10n/app_localizations.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _tagScrollController = ScrollController();
  final GlobalKey _tagListKey = GlobalKey();
  late final List<GlobalKey> _tagKeys;
  String _keyword = '';
  String _draftKeyword = '';
  String _selectedTag = 'ALL';

  final List<String> _tags = const [
    'ALL',
    'My',
    'BTS',
    'SEVENTEEN',
    'Stray Kids',
  ];

  final List<CreatorCardData> _allItems = const [
    CreatorCardData(
      name: '金泰亨',
      author: 'nightowl22_',
      tag: 'BTS',
      imageUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
    ),
    CreatorCardData(
      name: '崔胜澈',
      author: 'baramgyeol_112312312123',
      tag: 'SEVENTEEN',
      imageUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
    ),
    CreatorCardData(
      name: '李旻浩',
      author: 'lunia_',
      tag: 'Stray Kids',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=800&q=80',
    ),
    CreatorCardData(
      name: '田柾国',
      author: 'purple_rain',
      tag: 'BTS',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tagKeys = List.generate(_tags.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tagScrollController.dispose();
    super.dispose();
  }

  void _applySearch([String? value]) {
    final next = (value ?? _draftKeyword).trim();
    setState(() => _keyword = next);
    FocusScope.of(context).unfocus();
  }

  void _scrollSelectedTagToLeft(int index) {
    if (!_tagScrollController.hasClients) return;
    final listContext = _tagListKey.currentContext;
    final tagContext = _tagKeys[index].currentContext;
    if (listContext == null || tagContext == null) return;

    final listBox = listContext.findRenderObject() as RenderBox?;
    final tagBox = tagContext.findRenderObject() as RenderBox?;
    if (listBox == null || tagBox == null) return;

    final tagPos = tagBox.localToGlobal(Offset.zero, ancestor: listBox);
    final max = _tagScrollController.position.maxScrollExtent;
    var target = _tagScrollController.offset + tagPos.dx;
    if (target < 0) target = 0;
    if (target > max) target = max;

    _tagScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  List<CreatorCardData> get _filteredItems {
    final normalizedKeyword = _keyword.trim().toLowerCase();
    return _allItems.where((item) {
      final matchTag = _selectedTag == 'ALL' || item.tag == _selectedTag;
      final matchKeyword =
          normalizedKeyword.isEmpty ||
          item.name.toLowerCase().contains(normalizedKeyword) ||
          item.author.toLowerCase().contains(normalizedKeyword);
      return matchTag && matchKeyword;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final items = _filteredItems;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF5FF), Color(0xFFF5EDFF)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    t.discoverTitle,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3B0C56),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9A62F8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 26),
                        const SizedBox(width: 2), // ← 改这里控制 icon 和文字间距
                        Text(
                          t.discoverCreate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => setState(() => _draftKeyword = value),
                  onSubmitted: _applySearch,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: t.discoverSearchHint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFB7B7B7),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9A62F8),
                      size: 24,
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 44, minHeight: 40),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 44, minHeight: 40),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    suffixIcon: SizedBox(
                      width: 44,
                      height: 40,
                      child: Center(
                        child: Visibility(
                          visible: _draftKeyword.isNotEmpty,
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 40,
                            ),
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _draftKeyword = '';
                                _keyword = '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  key: _tagListKey,
                  controller: _tagScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _tags.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final selected = tag == _selectedTag;
                    return ChoiceChip(
                      key: _tagKeys[index],
                      showCheckmark: false,
                      label: Text(
                        tag,
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: selected
                              ? const Color(0xFF3B0C56)
                              : const Color(0xFF6B6B6B),
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedTag = tag);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollSelectedTagToLeft(index);
                        });
                      },
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      selectedColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF9A62F8)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.67,
                  ),
                  itemBuilder: (context, index) =>
                      CreatorCard(item: items[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

