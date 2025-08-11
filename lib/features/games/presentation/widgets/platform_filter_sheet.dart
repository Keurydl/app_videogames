import 'package:flutter/material.dart';
import '../pages/platform_games_page.dart';

class PlatformFilterSheet extends StatelessWidget {
  final List<String> platforms;
  const PlatformFilterSheet({Key? key, required this.platforms})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Elige una plataforma',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ...platforms.map((platform) {
          // Mapeo de nombre a ID RAWG
          final platformIdMap = {
            'PC': '4',
            'PlayStation 5': '187',
            'PlayStation 4': '18',
            'Xbox One': '1',
            'Xbox Series X': '186',
            'Nintendo Switch': '7',
            'iOS': '3',
            'Android': '21',
          };
          final id = platformIdMap[platform] ?? platform;
          return ListTile(
            leading: const Icon(Icons.devices),
            title: Text(platform),
            onTap: () {
              Navigator.pop(context); // Cierra el modal
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlatformGamesPage(platform: id),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
