import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../games/presentation/pages/offline_mode_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128), // Azul marino intenso
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1128),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'App de Videojuegos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AnimatedLogo(),
            const SizedBox(height: 32),
            _AnimatedTitle(),
            const SizedBox(height: 32),
            SizedBox(
              width: 220,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gamepad, color: Colors.white),
                label: const Text('Ver Juegos RAWG'),
                onPressed: () {
                  context.go('/rawg-games');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ABE4), // Azul eléctrico
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  minimumSize: const Size(double.infinity, 0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.offline_bolt, color: Colors.white),
                label: const Text('Modo Offline'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OfflineModePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ABE4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  minimumSize: const Size(double.infinity, 0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.videogame_asset, color: Colors.white),
                label: const Text('Ver Noticias'),
                onPressed: () {
                  context.go('/news');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ABE4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  minimumSize: const Size(double.infinity, 0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF00ABE4),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Image.asset('assets/images/logo.png', width: 90, height: 90),
        ),
      ),
    );
  }
}

class _AnimatedTitle extends StatefulWidget {
  const _AnimatedTitle();
  @override
  State<_AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<_AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(
      const Duration(milliseconds: 400),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'RAWG',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
