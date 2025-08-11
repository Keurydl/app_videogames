import 'package:flutter/material.dart';
import '../../data/repositories/rawg_repository.dart';
import '../../data/models/rawg_game_model.dart';

class PlatformGamesPage extends StatefulWidget {
  final String platform;
  const PlatformGamesPage({Key? key, required this.platform}) : super(key: key);

  @override
  State<PlatformGamesPage> createState() => _PlatformGamesPageState();
}

class _PlatformGamesPageState extends State<PlatformGamesPage> {
  late Future<List<RawgGame>> _recentGamesFuture;
  late Future<List<RawgGame>> _newGamesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.platform == 'top') {
      _recentGamesFuture = RawgRepository().fetchTopGames();
      _newGamesFuture = RawgRepository().fetchTopGames();
    } else if (widget.platform == 'new') {
      _recentGamesFuture = RawgRepository().fetchNewReleases();
      _newGamesFuture = RawgRepository().fetchNewReleases();
    } else {
      _recentGamesFuture = RawgRepository().fetchRecentGamesByPlatform(
        widget.platform,
      );
      _newGamesFuture = RawgRepository().fetchNewReleasesByPlatform(
        widget.platform,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (widget.platform == 'top') {
      appBarTitle = 'Top juegos';
    } else if (widget.platform == 'new') {
      appBarTitle = 'Nuevos lanzamientos';
    } else if (int.tryParse(widget.platform) != null) {
      appBarTitle = 'Juegos';
    } else {
      appBarTitle = 'Juegos para ${widget.platform}';
    }
    return DefaultTabController(
      length: (widget.platform == 'top' || widget.platform == 'new') ? 1 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: const Color(0xFF00ABE4),
          foregroundColor: Colors.white,
          bottom: (widget.platform == 'top' || widget.platform == 'new')
              ? null
              : const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Próximos'),
                    Tab(text: 'Nuevos'),
                  ],
                ),
        ),
        backgroundColor: const Color(0xFFE9F1FA),
        body: (widget.platform == 'top' || widget.platform == 'new')
            ? _buildGamesFuture(_recentGamesFuture)
            : TabBarView(
                children: [
                  _buildGamesFuture(_recentGamesFuture),
                  _buildGamesFuture(_newGamesFuture),
                ],
              ),
      ),
    );
  }

  Widget _buildGamesFuture(Future<List<RawgGame>> future) {
    return FutureBuilder<List<RawgGame>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay juegos para esta plataforma.'),
          );
        }
        final games = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              child: ListTile(
                leading: game.backgroundImage.isNotEmpty
                    ? Image.network(
                        game.backgroundImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.videogame_asset, size: 40),
                title: Text(
                  game.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Lanzamiento: \\${game.released}'),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}
