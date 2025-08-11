import 'package:flutter/material.dart';
import '../../data/models/rawg_game_model.dart';

class GameDetailOfflinePage extends StatelessWidget {
  final RawgGame game;
  const GameDetailOfflinePage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Juego (Offline)'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9F1FA),
      body: SingleChildScrollView(
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 60)),
                  ),
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
                  if (game.tips.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Curiosidades y Trucos:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00ABE4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...game.tips.map((tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 16)),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
