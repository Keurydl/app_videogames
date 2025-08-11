import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../cubit/game_offer_cubit.dart';
import '../cubit/game_offer_state.dart';

class GameOffersPage extends StatefulWidget {
  const GameOffersPage({super.key});

  @override
  State<GameOffersPage> createState() => _GameOffersPageState();
}

class _GameOffersPageState extends State<GameOffersPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<GameOfferCubit>().loadOffers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isLoadingMore) {
      _loadMoreOffers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _loadMoreOffers() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await context.read<GameOfferCubit>().loadMoreOffers();

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        context.read<GameOfferCubit>().clearSearch();
      } else {
        context.read<GameOfferCubit>().searchOffers(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas de Juegos', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            tooltip: 'Buscar ofertas',
            onPressed: () {
              showSearch(
                context: context,
                delegate: GameOfferSearch(_onSearchChanged),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            tooltip: 'Actualizar',
            onPressed: () {
              context.read<GameOfferCubit>()..loadOffers();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<GameOfferCubit, GameOfferState>(
        builder: (context, state) {
          if (state is GameOfferLoading) {
            return _buildLoadingIndicator();
          } else if (state is GameOfferError) {
            return _buildError(state.message);
          } else if (state is GameOfferLoaded) {
            if (state.offers.isEmpty) {
              return _buildNoResults();
            }
            return _buildGameList(state);
          }
          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videogame_asset_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Descubre las mejores ofertas en videojuegos',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Usa el botón de búsqueda para encontrar ofertas específicas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando ofertas...'),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<GameOfferCubit>().loadOffers(),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron ofertas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otros términos de búsqueda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameList(GameOfferLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.hasReachedMax
          ? state.offers.length
          : state.offers.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.offers.length) {
          return _buildLoadingIndicator();
        }
        return _buildGameCard(state.offers[index]);
      },
    );
  }

  Widget _buildGameCard(dynamic offer) {
    final theme = Theme.of(context);
    final priceFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final savings = (offer.savings ?? 0).toInt();
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navegar al detalle de la oferta
          context.go('/game-offers/${offer.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del juego
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: offer.thumbnail ?? '',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: Colors.grey[isDarkMode ? 800 : 200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[isDarkMode ? 800 : 200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 40, color: Colors.grey[500]),
                          const SizedBox(height: 8),
                          Text('No disponible', style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ),
                ),
                if (savings > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-$savings%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Detalles del juego
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (offer.description != null && offer.description!.isNotEmpty)
                    Text(
                      offer.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (offer.salePrice != null && offer.salePrice! > 0) ...[
                        Text(
                          priceFormatter.format(offer.normalPrice ?? 0),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          priceFormatter.format(offer.salePrice),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ] else if (offer.normalPrice != null) ...[
                        Text(
                          priceFormatter.format(offer.normalPrice),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ] else ...[
                        const Text('Gratis',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                      if (offer.platform != null && offer.platform!.isNotEmpty)
                        Text(
                          offer.platform!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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
  }
}

class GameOfferSearch extends SearchDelegate {
  final Function(String) onSearchChanged;

  GameOfferSearch(this.onSearchChanged);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      onSearchChanged(query);
    }
    return Container();
  }
}
