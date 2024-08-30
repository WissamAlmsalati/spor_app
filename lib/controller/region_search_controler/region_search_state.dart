part of 'region_search_cubit.dart';



abstract class RegionSearchState extends Equatable {
  const RegionSearchState();

  @override
  List<Object> get props => [];
}

class RegionSearchInitial extends RegionSearchState {}

class RegionSearchLoading extends RegionSearchState {}

class RegionSearchLoaded extends RegionSearchState {
  final List<String> regions;

  const RegionSearchLoaded(this.regions);

  @override
  List<Object> get props => [regions];
}

class RegionSearchError extends RegionSearchState {
  final String message;

  const RegionSearchError(this.message);

  @override
  List<Object> get props => [message];
}