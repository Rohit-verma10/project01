import 'package:flutter/material.dart';

const _ink = Color(0xFF173D2A);
const _green = Color(0xFF2E7D4F);

enum _NewsType { all, alerts, tips, market }

class _NewsItem {
  const _NewsItem({
    required this.title,
    required this.summary,
    required this.details,
    required this.category,
    required this.type,
    required this.icon,
    required this.color,
    required this.readTime,
  });

  final String title;
  final String summary;
  final String details;
  final String category;
  final String readTime;
  final _NewsType type;
  final IconData icon;
  final Color color;
}

const _items = <_NewsItem>[
  _NewsItem(
    title: 'Check field drainage after heavy rain',
    summary: 'Standing water around roots can affect crop health. Walk the field and clear blocked channels.',
    details: 'Inspect low-lying areas first and make sure drainage channels are clear. If water remains around plants, consider asking a local agriculture officer for crop-specific guidance.',
    category: 'Field alert',
    type: _NewsType.alerts,
    icon: Icons.water_damage_outlined,
    color: Color(0xFF4287A5),
    readTime: '2 min read',
  ),
  _NewsItem(
    title: 'A simple weekly crop scouting routine',
    summary: 'Check several points across your field and note changes in leaves, stems, and soil.',
    details: 'Choose a few representative spots across the field, including edges and interior rows. Record visible changes each week and take photos from similar angles to make comparisons easier.',
    category: 'Farm tip',
    type: _NewsType.tips,
    icon: Icons.visibility_outlined,
    color: Color(0xFF4B8C58),
    readTime: '3 min read',
  ),
  _NewsItem(
    title: 'Compare local mandi prices before selling',
    summary: 'Prices can vary by market and grade. Check more than one nearby source before deciding.',
    details: 'Use current local market information and compare the same crop grade, unit, and date. These sample updates do not include live market prices.',
    category: 'Market note',
    type: _NewsType.market,
    icon: Icons.currency_rupee_rounded,
    color: Color(0xFFB17B37),
    readTime: '2 min read',
  ),
  _NewsItem(
    title: 'Keep irrigation equipment ready',
    summary: 'A quick check of filters, pipes, and emitters can help prevent uneven watering.',
    details: 'Inspect visible leaks and clean filters according to the equipment manufacturer’s guidance. Regular checks can help identify blockages before they affect a larger area.',
    category: 'Farm tip',
    type: _NewsType.tips,
    icon: Icons.water_drop_outlined,
    color: Color(0xFF43857E),
    readTime: '2 min read',
  ),
  _NewsItem(
    title: 'Watch for unusual crop changes',
    summary: 'New spots, wilting, or uneven growth may need closer inspection before treatment.',
    details: 'Photograph affected plants and check whether the pattern is spreading. Avoid applying treatments based only on a single symptom; consult a local crop expert for diagnosis.',
    category: 'Crop health',
    type: _NewsType.alerts,
    icon: Icons.health_and_safety_outlined,
    color: Color(0xFFAC5E4C),
    readTime: '3 min read',
  ),
];

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _searchController = TextEditingController();
  _NewsType _selectedType = _NewsType.all;
  String _search = '';
  final Set<String> _savedItems = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_NewsItem> get _filteredItems => _items.where((item) {
        final matchesType = _selectedType == _NewsType.all || item.type == _selectedType;
        final query = _search.toLowerCase();
        final matchesSearch = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.summary.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
        return matchesType && matchesSearch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News & alerts')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;
          final items = _filteredItems;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(wide ? 32 : 20, 16, wide ? 32 : 20, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(wide),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _search = value.trim()),
                      decoration: InputDecoration(
                        hintText: 'Search updates',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _search.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _search = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _filterChip('All', _NewsType.all),
                          _filterChip('Alerts', _NewsType.alerts),
                          _filterChip('Farm tips', _NewsType.tips),
                          _filterChip('Market notes', _NewsType.market),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Latest updates', style: TextStyle(color: _ink, fontSize: 19, fontWeight: FontWeight.w800)),
                        ),
                        Text('${items.length} items', style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12)),
                      ],
                    ),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: _emptyState(),
                      )
                    else if (wide)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: constraints.maxWidth >= 1120 ? 3 : 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            mainAxisExtent: 220,
                          ),
                          itemBuilder: (context, index) => _newsCard(items[index]),
                        ),
                      )
                    else
                      ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _newsCard(item),
                          )),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool wide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_ink, Color(0xFF36764B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Stay informed', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Sample farm reminders and practical reading. Live news is not connected yet.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.82), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.campaign_rounded, color: Color(0xFFD4E9CF), size: 38),
        ],
      ),
    );
  }

  Widget _filterChip(String label, _NewsType type) {
    final selected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _selectedType = type),
        selectedColor: const Color(0xFFDDEBDD),
        labelStyle: TextStyle(color: selected ? _ink : Colors.blueGrey.shade700, fontWeight: FontWeight.w600),
        side: BorderSide(color: selected ? const Color(0xFFB8D2BA) : const Color(0xFFE2E8E0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _newsCard(_NewsItem item) {
    final saved = _savedItems.contains(item.title);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
        side: const BorderSide(color: Color(0xFFE5EAE3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(item.icon, color: item.color, size: 21),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.category.toUpperCase(), style: TextStyle(color: item.color, fontSize: 10, letterSpacing: 0.9, fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                    tooltip: saved ? 'Remove saved item' : 'Save item',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() {
                      if (saved) {
                        _savedItems.remove(item.title);
                      } else {
                        _savedItems.add(item.title);
                      }
                    }),
                    icon: Icon(saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: saved ? _green : Colors.blueGrey.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Text(item.title, style: const TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800, height: 1.25)),
              const SizedBox(height: 7),
              Expanded(
                child: Text(
                  item.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.blueGrey.shade600, height: 1.4, fontSize: 12),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 14, color: Colors.blueGrey.shade400),
                  const SizedBox(width: 5),
                  Text(item.readTime, style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11)),
                  const Spacer(),
                  const Text('Read more', style: TextStyle(color: _green, fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 14, color: _green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 42, color: Colors.blueGrey.shade300),
          const SizedBox(height: 10),
          const Text('No matching updates', style: TextStyle(color: _ink, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Try another search or category.', style: TextStyle(color: Colors.blueGrey.shade600)),
        ],
      ),
    );
  }

  void _showDetails(_NewsItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 26),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: item.color.withValues(alpha: 0.12), child: Icon(item.icon, color: item.color)),
                    const SizedBox(width: 10),
                    Text(item.category, style: TextStyle(color: item.color, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(item.title, style: const TextStyle(color: _ink, fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(item.details, style: TextStyle(color: Colors.blueGrey.shade700, height: 1.55)),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
