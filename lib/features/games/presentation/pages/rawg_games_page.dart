import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/rawg_games_cubit.dart';
import 'rawg_games_page_extra.dart';
import '../widgets/platform_filter_sheet.dart';
import '../widgets/genre_filter_sheet.dart';
import 'platform_games_page.dart';

class RawgGamesPage extends StatelessWidget {
  const RawgGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cargar secciones al entrar
    context.read<RawgGamesCubit>().loadAllSections();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos RAWG'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      backgroundColor: const Color(0xFFE9F1FA),
      body: BlocBuilder<RawgGamesCubit, RawgGamesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Section(
                icon: Icons.local_fire_department_rounded,
                iconColor: Color(0xFFFF9800),
                title: 'Nuevos lanzamientos',
                games: state.newReleases,
              ),
              const SizedBox(height: 24),
              Section(
                icon: Icons.rocket_launch_rounded,
                iconColor: Color(0xFF00ABE4),
                title: 'Próximos lanzamientos',
                games: state.upcoming,
              ),
              const SizedBox(height: 24),
              Section(
                icon: Icons.emoji_events_rounded,
                iconColor: Color(0xFF2196F3),
                title: 'Top juegos',
                games: state.top,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE9F1FA),
        selectedItemColor: const Color(0xFF00ABE4),
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              // Próximos lanzamientos
              // Si ya está en la pantalla principal, solo hacer scroll al apartado, si no, navegar aquí
              // Aquí podrías implementar un scroll automático al apartado 'Próximos lanzamientos',
              // pero como mejora rápida, simplemente no navegamos a RecentGamesPage.
              // Opcional: mostrar un SnackBar indicando que ya estás viendo próximos lanzamientos.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ya estás viendo Todos los juegos'),
                ),
              );
              break;
            case 1:
              // Top
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlatformGamesPage(
                    platform: 'top', // Usar palabra clave para distinguir
                  ),
                ),
              );
              break;
            case 2:
              // Nuevos
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlatformGamesPage(
                    platform: 'new', // Usar palabra clave para distinguir
                  ),
                ),
              );
              break;
            case 3:
              // Plataformas
              showModalBottomSheet(
                context: context,
                builder: (_) => PlatformFilterSheet(
                  platforms: const [
                    'PC',
                    'PlayStation 5',
                    'PlayStation 4',
                    'Xbox One',
                    'Xbox Series X',
                    'Nintendo Switch',
                    'iOS',
                    'Android',
                  ],
                ),
              );
              break;
            case 4:
              // Géneros
              showModalBottomSheet(
                context: context,
                builder: (_) => GenreFilterSheet(
                  genres: const [
                    'Action',
                    'RPG',
                    'Indie',
                    'Shooter',
                    'Adventure',
                    'Puzzle',
                    'Racing',
                    'Sports',
                    'Strategy',
                    'Simulation',
                  ],
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Todos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Top',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Nuevos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Plataformas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Géneros'),
        ],
      ),
    );
  }
}
