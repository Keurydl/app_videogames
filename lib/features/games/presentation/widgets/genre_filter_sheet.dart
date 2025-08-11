import 'package:flutter/material.dart';
import '../pages/genre_games_page.dart';

class GenreFilterSheet extends StatelessWidget {
  final List<String> genres;
  const GenreFilterSheet({Key? key, required this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Elige un género', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        ...genres.map((genre) => ListTile(
              leading: const Icon(Icons.category),
              title: Text(genre),
              onTap: () {
                Navigator.pop(context); // Cierra el modal
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GenreGamesPage(genre: genre),
                  ),
                );
              },
            )),
      ],
    );
  }
}
