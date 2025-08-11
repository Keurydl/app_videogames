import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_final/features/news/data/repositories/igdb_repository.dart';
import 'package:proyect_final/features/news/presentation/cubit/igdb_news_cubit.dart';

class IGDBProviders extends StatelessWidget {
  final Widget child;

  const IGDBProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IGDBRepository>(
          create: (context) => IGDBRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<IGDBNewsCubit>(
            create: (context) => IGDBNewsCubit(
              igdbRepository: context.read<IGDBRepository>(),
            )..loadNews(),
          ),
        ],
        child: child,
      ),
    );
  }
}