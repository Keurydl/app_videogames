import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/rawg_repository.dart';
import '../cubit/game_detail_cubit.dart';

class GameDetailPage extends StatelessWidget {
  final int gameId;
  const GameDetailPage({Key? key, required this.gameId}) : super(key: key);

  Widget _buildGameDetail(GameDetailLoaded state) {
    final game = state.game;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (game.backgroundImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                game.backgroundImage,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color(0xFF0A1128),
                  ),
                ),
                const SizedBox(height: 8),
                // Barra de plataformas RAWG
                if (game.platforms.isNotEmpty)
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: game.platforms.map<Widget>((platform) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            platform,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF00ABE4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Color(0xFF00ABE4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lanzamiento: ${game.released}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (game.rating > 0)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${game.rating}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                if (game.genres.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: game.genres
                        .map((g) => Chip(label: Text(g)))
                        .toList(),
                  ),
                const SizedBox(height: 20),
                if (game.description.isNotEmpty)
                  Text(
                    game.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  const Text(
                    'Sin descripción disponible.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameDetailCubit(RawgRepository())..fetchDetails(gameId),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Detalles del Juego'),
            backgroundColor: const Color(0xFF00ABE4),
            foregroundColor: Colors.white,
            actions: [
              BlocBuilder<GameDetailCubit, GameDetailState>(
                builder: (context, state) {
                  if (state is GameDetailLoaded) {
                    return IconButton(
                      icon: Icon(
                        state.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        context.read<GameDetailCubit>().toggleSaveGame(
                          state.game,
                        );
                      },
                      tooltip: state.isSaved
                          ? 'Eliminar de guardados'
                          : 'Guardar para offline',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          backgroundColor: const Color(0xFFE9F1FA),
          body: BlocConsumer<GameDetailCubit, GameDetailState>(
            listener: (context, state) {
              if (state is GameSaveError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is GameDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GameDetailError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is GameDetailLoaded) {
                // Mostrar mensaje de éxito al guardar/eliminar
                if (state is GameSavedSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.isSaved
                              ? 'Juego guardado para ver offline'
                              : 'Juego eliminado de guardados',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: state.isSaved
                            ? Colors.green
                            : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  });
                }

                return _buildGameDetail(state);
              }

              return const Center(
                child: Text('No se pudo cargar la información del juego'),
              );
            },
          ),
        ),
      ),
    );
  }
}
