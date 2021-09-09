part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;
  OnLocationUpdate(this.ubicacion);
}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnCrearRutaInicialDestino extends MapaEvent {
  final List<LatLng> rutaCordenadas;
  final double distancia;
  final double duracion;
  final String nombreDestino;

  OnCrearRutaInicialDestino(this.rutaCordenadas, this.distancia, this.duracion, this.nombreDestino);
}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);
}
