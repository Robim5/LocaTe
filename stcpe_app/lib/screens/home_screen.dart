import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/bus_line.dart';
import '../widgets/bento_favorites.dart';
import '../widgets/bus_list_item.dart';
import 'bus_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Todos';

  List<BusLine> get _filteredLines {
    if (_selectedFilter == 'Todos') return MockData.busLines;
    return MockData.busLines
        .where((l) => l.municipality == _selectedFilter)
        .toList();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 19) return 'Boa tarde';
    return 'Boa noite';
  }

  void _toggleFavorite(BusLine line) {
    setState(() => line.isFavorite = !line.isFavorite);
  }

  void _openDetail(BusLine line) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BusDetailScreen(busLine: line)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredLines;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                  const Text(
                    'STCPe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: SearchBar(
                leading: Icon(Icons.search_rounded,
                    color: theme.colorScheme.primary),
                hintText: 'Pesquisar linha ou paragem...',
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),

          // favourites title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Os Teus Favoritos',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
            ),
          ),

          // bento grid 
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BentoFavorites(),
            ),
          ),

          // lines title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 4),
              child: Text(
                'Linhas',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // filters line
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: MockData.municipalities.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final name = MockData.municipalities[i];
                  return FilterChip(
                    label: Text(name),
                    selected: _selectedFilter == name,
                    onSelected: (_) =>
                        setState(() => _selectedFilter = name),
                  );
                },
              ),
            ),
          ),

          // bus list
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48,
                          color:
                              theme.colorScheme.onSurface.withAlpha(77)),
                      const SizedBox(height: 12),
                      Text(
                        'Sem linhas neste munic\u00edpio',
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final line = filtered[i];
                  return BusListItem(
                    busLine: line,
                    onTap: () => _openDetail(line),
                    onFavoriteToggle: () => _toggleFavorite(line),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

