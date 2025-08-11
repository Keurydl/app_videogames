import 'package:flutter/material.dart';
import '../../data/repositories/rawg_repository.dart';
import '../../data/models/rawg_game_model.dart';

class GenreGamesPage extends StatefulWidget {
  final String genre;
  const GenreGamesPage({Key? key, required this.genre}) : super(key: key);

  @override
  State<GenreGamesPage> createState() => _GenreGamesPageState();
}

class _GenreGamesPageState extends State<GenreGamesPage> {
  late Future<List<RawgGame>> _recentGamesFuture;
  late Future<List<RawgGame>> _newGamesFuture;

  @override
  void initState() {
    super.initState();
    final genreSlugMap = {
      'Action': 'action',
      'RPG': 'role-playing-games-rpg',
      'Indie': 'indie',
      'Shooter': 'shooter',
      'Adventure': 'adventure',
      'Puzzle': 'puzzle',
      'Racing': 'racing',
      'Platformer': 'platformer',
      'Strategy': 'strategy',
      'Simulation': 'simulation',
      'Sports': 'sports',
      'Fighting': 'fighting',
      'Family': 'family',
      'Arcade': 'arcade',
      'Casual': 'casual',
      'Card': 'card',
      'Board Games': 'board-games',
      'Educational': 'educational',
      'Massively Multiplayer': 'massively-multiplayer',
      // Agrega más si los usas en el modal
    };
    final slug = genreSlugMap[widget.genre] ?? widget.genre.toLowerCase();
    _recentGamesFuture = RawgRepository().fetchRecentGamesByGenre(slug);
    _newGamesFuture = RawgRepository().fetchNewReleasesByGenre(slug);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Juegos de ${widget.genre}'),
          backgroundColor: const Color(0xFF00ABE4),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Próximos'),
              Tab(text: 'Nuevos'),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFE9F1FA),
        body: TabBarView(
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
          return const Center(child: Text('No hay juegos para este género.'));
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
                    ? Image.network(game.backgroundImage, width: 60, height: 60, fit: BoxFit.cover)
                    : const Icon(Icons.videogame_asset, size: 40),
                title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
