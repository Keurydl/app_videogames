import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyect_final/features/games/presentation/pages/game_offers_page.dart';
import 'package:proyect_final/features/games/presentation/pages/rawg_games_page.dart';
import 'package:proyect_final/features/news/presentation/pages/home_page.dart';
import 'package:proyect_final/features/news/presentation/pages/news_list_page.dart';

class AppRouter {
  // Rutas con nombre para facilitar la navegación
  static const String home = '/';
  static const String news = '/news';
  static const String newsDetail = '/news/:id';
  static const String gameOffers = '/game-offers';
  static const String gameDetail = '/game-offers/:id';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      // Ruta de inicio
      GoRoute(
        path: home,
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),

      // Ruta de ofertas de juegos
      GoRoute(
        path: gameOffers,
        pageBuilder: (context, state) =>
            const MaterialPage(child: GameOffersPage()),
      ),

      // Ruta de juegos RAWG
      GoRoute(
        path: '/rawg-games',
        pageBuilder: (context, state) => const MaterialPage(child: RawgGamesPage()),
      ),

      // Ruta de noticias de videojuegos
      GoRoute(
        path: news,
        pageBuilder: (context, state) => const MaterialPage(child: NewsListPage()),
      ),

      // Ruta de detalle de oferta de juego
      GoRoute(
        path: gameDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          // TODO: Implementar página de detalle de oferta
          return MaterialPage(
            child: Scaffold(
              appBar: AppBar(title: const Text('Detalle de Oferta')),
              body: Center(
                child: Text('Detalles de la oferta $id (próximamente)'),
              ),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Página no encontrada', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text(
              'No se pudo encontrar la ruta: ${state.uri.path}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
