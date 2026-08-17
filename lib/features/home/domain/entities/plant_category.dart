import 'package:equatable/equatable.dart';

/// A plant category shown in the grid on the home screen.
class PlantCategory extends Equatable {
  const PlantCategory({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.rank,
  });

  final int id;
  final String title;
  final String imageUrl;
  final int? rank;

  @override
  List<Object?> get props => <Object?>[id, title, imageUrl, rank];
}
