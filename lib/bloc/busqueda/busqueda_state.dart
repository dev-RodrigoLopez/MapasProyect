part of 'busqueda_bloc.dart';

@immutable
class BusquedaState{

  final bool seleccionManuual;
  final List<SearchResult> historial;

  BusquedaState({
    this.seleccionManuual = false,
    List<SearchResult> historial
  }) : this.historial = ( historial == null ) ? [] : historial;

  BusquedaState copyWith({
    bool seleccionManuual,
    List<SearchResult> historial
  }) => BusquedaState(
    seleccionManuual: seleccionManuual ?? this.seleccionManuual,
    historial: historial ?? this.historial,
  );

}