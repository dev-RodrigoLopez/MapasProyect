part of 'busqueda_bloc.dart';

@immutable
class BusquedaState{

  final bool seleccionManuual;

  BusquedaState({
    this.seleccionManuual = false
  });

  BusquedaState copyWith({
    bool seleccionManuual 
  }) => BusquedaState(
    seleccionManuual: seleccionManuual ?? this.seleccionManuual
  );

}