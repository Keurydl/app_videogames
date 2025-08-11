import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyect_final/app/app.dart';
import 'package:proyect_final/core/theme/app_theme.dart';
import 'package:proyect_final/features/games/data/repositories/game_offer_repository.dart';
import 'package:proyect_final/features/games/presentation/cubit/game_offer_cubit.dart';
import 'package:proyect_final/features/news/data/repositories/news_repository.dart';
import 'package:proyect_final/features/news/presentation/cubit/news_cubit.dart';
import 'package:proyect_final/features/games/data/repositories/rawg_repository.dart';
import 'package:proyect_final/features/games/presentation/cubit/rawg_games_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar datos de localización para el paquete intl
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newsRepository = NewsRepository();
    final gameOfferRepository = GameOfferRepository();

    return MultiBlocProvider(
      providers: [
        // Provider para el cubit de noticias
        BlocProvider<NewsCubit>(
          create: (context) =>
              NewsCubit(newsRepository: newsRepository)..loadNews(),
        ),
        // Provider para el cubit de ofertas de juegos
        BlocProvider<GameOfferCubit>(
          create: (context) =>
              GameOfferCubit(gameOfferRepository)..loadOffers(),
        ),
        // Provider para el cubit de juegos RAWG
        BlocProvider<RawgGamesCubit>(
          create: (context) =>
              RawgGamesCubit(RawgRepository())..loadAllSections(),
        ),
      ],
      child: MaterialApp.router(
        title: 'App de Videojuegos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
