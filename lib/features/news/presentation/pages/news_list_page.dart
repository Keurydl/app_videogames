import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _articles = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews([String query = 'video games']) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final url = Uri.parse('https://newsapi.org/v2/everything?q=$query&language=en&sortBy=publishedAt&apiKey=2dd3bc8bfbd940d2a114ab1c60e3ae58');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _articles = data['articles'];
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Usa go_router si está disponible, si no, Navigator
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: const Text('Noticias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await _showSearchDialog(context);
              if (query != null && query.isNotEmpty) {
                fetchNews(query);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchNews();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 6,
                      child: InkWell(
                        onTap: () {
                          if (article['url'] != null) {
                            // Puedes usar url_launcher para abrir el enlace
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                child: Image.network(
                                  article['urlToImage'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 48),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'] ?? '',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article['description'] ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        article['source']?['name'] ?? '',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.blueAccent),
                                      ),
                                      Text(
                                        article['publishedAt'] != null ? article['publishedAt'].toString().substring(0, 10) : '',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<String?> _showSearchDialog(BuildContext context) async {
    final searchController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar noticias'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Ingrese su búsqueda',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final query = searchController.text.trim();
              Navigator.of(context).pop(query);
            },
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }
}
