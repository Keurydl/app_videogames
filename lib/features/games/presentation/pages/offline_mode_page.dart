import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/saved_games_cubit.dart';
import 'saved_games_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simula almacenamiento local de juegos guardados
class LocalSavedGamesStorage {
  Future<List<String>> getSavedGames() async {
    // Devuelve una lista simulada
    return Future.value(['Juego 1', 'Juego 2']);
  }
}

// Simula almacenamiento local de artículos guardados
class LocalArticleStorage {
  Future<List<String>> getSavedArticles() async {
    // Devuelve una lista simulada
    return Future.value(['Artículo 1', 'Artículo 2']);
  }
}

// Pantalla de lista de mini-juegos
class MiniGamesListPage extends StatelessWidget {
  const MiniGamesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini-juegos'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9F1FA),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.memory, color: Color(0xFF00ABE4), size: 32),
                  title: const Text(
                    'Juego de Memoria',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 243, 243, 243),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MemoryGamePage()),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00ABE4)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              // Puedes agregar más mini-juegos aquí
            ],
          ),
    );
  }
}


class OfflineModePage extends StatelessWidget {
  const OfflineModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Offline'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9F1FA),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Modo Offline: Explora y juega sin conexión',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A1128),
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _OfflineSquareButton(
                icon: Icons.quiz,
                iconColor: const Color(0xFF00ABE4),
                label: 'Quiz',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QuizPage()),
                  );
                },
              ),
              _OfflineSquareButton(
                icon: Icons.videogame_asset,
                iconColor: const Color(0xFF00ABE4),
                label: 'Juegos Clásicos',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DemoGamesPage()),
                  );
                },
              ),
              _OfflineSquareButton(
                icon: Icons.bar_chart,
                iconColor: const Color(0xFF00ABE4),
                label: 'Estadísticas',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OfflineStatsPage()),
                  );
                },
              ),
              _OfflineSquareButton(
                icon: Icons.extension,
                iconColor: const Color(0xFF00ABE4),
                label: 'Mini-juegos',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MiniGamesListPage()),
                  );
                },
              ),
              _OfflineSquareButton(
                icon: Icons.bookmark,
                iconColor: const Color(0xFF00ABE4),
                label: 'Juegos Guardados',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => SavedGamesCubit()..loadSavedGames(),
                        child: const SavedGamesPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OfflineStatsPage extends StatefulWidget {
  const OfflineStatsPage({Key? key}) : super(key: key);

  @override
  State<OfflineStatsPage> createState() => _OfflineStatsPageState();
}

class _OfflineStatsPageState extends State<OfflineStatsPage> {
  int savedGames = 0;
  int savedArticles = 0;
  int triviasPlayed = 0;
  int maxTriviaScore = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // Juegos guardados
    final gamesStorage = LocalSavedGamesStorage();
    final games = await gamesStorage.getSavedGames();
    setState(() {
      savedGames = games.length;
    });

    // Artículos guardados
    final articleStorage = LocalArticleStorage();
    final articles = await articleStorage.getSavedArticles();
    setState(() {
      savedArticles = articles.length;
    });

    // Trivias jugadas y puntaje máximo
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      triviasPlayed = prefs.getInt('trivias_played') ?? 0;
      maxTriviaScore = prefs.getInt('max_trivia_score') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas Offline'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tus estadísticas en modo offline',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Color(0xFF00ABE4), size: 36),
              title: const Text('Juegos guardados', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(savedGames.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: Color(0xFF00C853), size: 36),
              title: const Text('Trivias jugadas', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(triviasPlayed.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Color(0xFFFFA000), size: 36),
              title: const Text('Puntaje máx. trivia', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(maxTriviaScore.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                '¡Sigue jugando para mejorar tus estadísticas!',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- Pantalla básica de juego de memoria ---

class _MemoryCard {
  final String content;
  bool revealed;
  _MemoryCard(this.content) : revealed = false;
}

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late List<_MemoryCard> cards;
  int? firstSelected;
  int? secondSelected;
  int matches = 0;
  int tries = 0;
  bool waiting = false;
  bool finished = false;

  final List<String> emojis = [
    '🎮', '👾', '🕹️', '⭐',
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    final all = List<String>.from(emojis + emojis);
    all.shuffle(Random());
    cards = List.generate(all.length, (i) => _MemoryCard(all[i]));
    setState(() {
      firstSelected = null;
      secondSelected = null;
      matches = 0;
      tries = 0;
      waiting = false;
      finished = false;
    });
  }

  void _onCardTap(int idx) async {
    if (waiting || cards[idx].revealed || finished) return;
    setState(() {
      if (firstSelected == null) {
        firstSelected = idx;
        cards[idx].revealed = true;
      } else if (secondSelected == null && idx != firstSelected) {
        secondSelected = idx;
        cards[idx].revealed = true;
        tries++;
        waiting = true;
      }
    });

    if (firstSelected != null && secondSelected != null) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (cards[firstSelected!].content == cards[secondSelected!].content) {
        setState(() {
          matches++;
          if (matches == emojis.length) finished = true;
        });
      } else {
        setState(() {
          cards[firstSelected!].revealed = false;
          cards[secondSelected!].revealed = false;
        });
      }
      setState(() {
        firstSelected = null;
        secondSelected = null;
        waiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Memoria'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 3, 3, 3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pares encontrados: $matches/${emojis.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Intentos: $tries', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 18),
            SizedBox(
              width: 280,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, i) {
                  final card = cards[i];
                  return GestureDetector(
                    onTap: () => _onCardTap(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: card.revealed ? Colors.white : const Color(0xFF00ABE4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        card.revealed ? card.content : '',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            if (finished)
              Column(
                children: [
                  const Text('¡Felicidades! Has encontrado todos los pares.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Jugar de nuevo'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
// ...existing code...

class _OfflineSquareButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _OfflineSquareButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: iconColor, size: 38),
                    const SizedBox(height: 12),
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0A1128),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoGamesPage extends StatelessWidget {
  const DemoGamesPage({Key? key}) : super(key: key);

  static final List<Map<String, String>> demoGames = [
    {
      'name': 'Super Mario Bros.',
      'platform': 'NES',
      'year': '1985',
      'desc': 'Un clásico de plataformas que revolucionó la industria.',
    },
    {
      'name': 'The Legend of Zelda',
      'platform': 'NES',
      'year': '1986',
      'desc': 'Aventura y exploración en el mundo de Hyrule.',
    },
    {
      'name': 'Tetris',
      'platform': 'Game Boy',
      'year': '1989',
      'desc': 'El puzzle más famoso de todos los tiempos.',
    },
    {
      'name': 'Sonic the Hedgehog',
      'platform': 'Genesis',
      'year': '1991',
      'desc': 'La mascota de SEGA en un juego de velocidad y plataformas.',
    },
    {
      'name': 'Pokémon Red/Blue',
      'platform': 'Game Boy',
      'year': '1996',
      'desc': 'Atrapa y entrena criaturas en Kanto.',
    },
    {
      'name': 'DOOM',
      'platform': 'PC',
      'year': '1993',
      'desc': 'El shooter en primera persona que definió un género.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos Demo'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9F1FA),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoGames.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final game = demoGames[i];
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.videogame_asset,
                color: Color(0xFF0A1128),
              ),
              title: Text(game['name']!),
              subtitle: Text(
                '${game['platform']} • ${game['year']}\n${game['desc']}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _answered = false;
  int? _selectedIndex;
  bool _showCorrectAnswer = false;
  final List<Map<String, dynamic>> questions = [
    {
      'question': '¿Cuál fue la primera consola de videojuegos doméstica?',
      'options': ['NES', 'Magnavox Odyssey', 'Atari 2600', 'ColecoVision'],
      'answer': 1,
    },
    {
      'question': '¿Qué personaje es la mascota de SEGA?',
      'options': ['Mario', 'Sonic', 'Crash Bandicoot', 'Kirby'],
      'answer': 1,
    },
    {
      'question': '¿En qué año salió Pokémon Rojo/Azul?',
      'options': ['1999', '1996', '1992', '2000'],
      'answer': 1,
    },
    {
      'question': '¿Qué juego popularizó el género Battle Royale?',
      'options': ['PUBG', 'Fortnite', 'Apex Legends', 'Minecraft'],
      'answer': 0,
    },
    {
      'question': '¿Quién es el creador de Mario?',
      'options': [
        'Shigeru Miyamoto',
        'Hideo Kojima',
        'Satoru Iwata',
        'Gabe Newell',
      ],
      'answer': 0,
    },
  ];
  int current = 0;
  int score = 0;
  bool finished = false;

  void answer(int selected) async {
    if (finished || _answered) return;

    setState(() {
      _answered = true;
      _selectedIndex = selected;
      _showCorrectAnswer = (selected != questions[current]['answer']);
      if (selected == questions[current]['answer']) {
        score++;
      }
    });

    if (current < questions.length - 1) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          current++;
          _answered = false;
          _selectedIndex = null;
          _showCorrectAnswer = false;
        });
      }
    } else {
      // Al terminar, guardar estadísticas
      final prefs = await SharedPreferences.getInstance();
      int played = prefs.getInt('trivias_played') ?? 0;
      int maxScore = prefs.getInt('max_trivia_score') ?? 0;
      await prefs.setInt('trivias_played', played + 1);
      if (score > maxScore) {
        await prefs.setInt('max_trivia_score', score);
      }
      setState(() {
        finished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Gamer'),
        backgroundColor: const Color(0xFF00ABE4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0A1128),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: finished
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 64,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '¡Puntaje final: $score/${questions.length}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        current = 0;
                        score = 0;
                        finished = false;
                        _answered = false;
                        _selectedIndex = null;
                        _showCorrectAnswer = false;
                      }),
                      child: const Text('Jugar otra vez'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Pregunta ${current + 1}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      q['question'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1128),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(q['options'].length, (i) {
                    bool isSelected = _selectedIndex == i;
                    bool isCorrect = i == q['answer'];
                    
                    Color buttonColor = Colors.white;
                    Color textColor = const Color(0xFF0A1128);
                    
                    if (_answered) {
                      if (isSelected) {
                        buttonColor = isCorrect ? Colors.green : Colors.red;
                        textColor = Colors.white;
                      } else if (isCorrect && _showCorrectAnswer) {
                        buttonColor = Colors.green;
                        textColor = Colors.white;
                      } else {
                        buttonColor = Colors.grey[200]!;
                      }
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: buttonColor,
                          side: BorderSide(
                            color: _answered && isSelected ? buttonColor : const Color(0xFF00ABE4),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _answered ? null : () => answer(i),
                        child: Text(
                          q['options'][i],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_showCorrectAnswer && _answered)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            '¡Incorrecto! La respuesta correcta es: ${q['options'][q['answer']]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (current < questions.length - 1) {
                                current++;
                                _answered = false;
                                _selectedIndex = null;
                                _showCorrectAnswer = false;
                              } else {
                                finished = true;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  if (_answered && !_showCorrectAnswer)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        '¡Correcto!',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
