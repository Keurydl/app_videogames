import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/saved_games_cubit.dart';
import '../../data/models/rawg_game_model.dart';
import 'game_detail_offline_page.dart';

class SavedGamesPage extends StatelessWidget {
  const SavedGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos Guardados'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9F1FA),
      body: BlocBuilder<SavedGamesCubit, SavedGamesState>(
        builder: (context, state) {
          if (state is SavedGamesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedGamesError) {
            return Center(child: Text(state.message));
          } else if (state is SavedGamesLoaded) {
            if (state.games.isEmpty) {
              return const Center(
                child: Text('No hay juegos guardados'),
              );
            }
            return _buildGamesList(state.games, context);
          } else {
            return const Center(child: Text('Cargando juegos...'));
          }
        },
      ),
    );
  }

  Widget _buildGamesList(List<RawgGame> games, BuildContext context) {
    // Ordenar juegos alfabéticamente
    games.sort((a, b) => a.name.compareTo(b.name));
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Dismissible(
          key: ValueKey(game.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Eliminar juego'),
                content: Text('¿Estás seguro de que quieres eliminar ${game.name}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            context.read<SavedGamesCubit>().removeGame(game);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${game.name} eliminado')),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
              subtitle: Text(
                game.released,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameDetailOfflinePage(game: game),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
