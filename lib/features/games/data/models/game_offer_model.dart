import 'package:equatable/equatable.dart';

class GameOffer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String type;
  final String platform;
  final double? normalPrice;
  final double? salePrice;
  final double? savings;
  final String? store;
  final DateTime? endDate;

  const GameOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.type,
    required this.platform,
    this.normalPrice,
    this.salePrice,
    this.savings,
    this.store,
    this.endDate,
  });

  factory GameOffer.fromJson(Map<String, dynamic> json) {
    return GameOffer(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Sin título',
      description: json['short_description'] ?? '',
      imageUrl: json['thumbnail'] ?? '',
      url: json['game_url'] ?? '',
      type: json['type'] ?? 'game',
      platform: json['platform'] ?? 'PC',
      normalPrice: json['normal_price']?.toDouble(),
      salePrice: json['sale_price']?.toDouble(),
      savings: json['savings']?.toDouble(),
      store: json['store'],
      endDate: json['end_date'] != null 
          ? DateTime.tryParse(json['end_date']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        url,
        type,
        platform,
        normalPrice,
        salePrice,
        savings,
        store,
        endDate,
      ];
}
