import 'package:equatable/equatable.dart';

/// A "Get Started" article card in the horizontal carousel.
class Question extends Equatable {
  const Question({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.uri,
    this.order,
  });

  final int id;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? uri;
  final int? order;

  @override
  List<Object?> get props => <Object?>[id, title, imageUrl, subtitle, uri, order];
}
