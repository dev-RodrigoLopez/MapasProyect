import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  //Controlador del mapa
  GoogleMapController _mapController;

  //Polylines
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('mi_ruta'), width: 3, color: Colors.transparent);

  //Polylines
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('mi_ruta_destino'), width: 3, color: Colors.black);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;

      // this._mapController.setMapStyle(mapStyle)

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final camaraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(camaraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnLocationUpdate) {
      yield* this._onLocationUpdate(event);
    } else if (event is OnMarcarRecorrido) {
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      // print( event.centroMapa );
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearRutaInicialDestino) {
      yield* _onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onLocationUpdate(OnLocationUpdate event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }

    List<LatLng> points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.blue[400]);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }

    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicialDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    //Marcadores
    final markerInicio = new Marker(
      markerId: MarkerId('inicio'),
      position: event.rutaCordenadas[0],
      infoWindow: InfoWindow(
        title: 'Mi ubicacion',
        snippet: 'Recorrido: ${ (event.duracion / 60).floor() } minutos',
        // anchor: Offset( 0.5,  0 ) ,
        // onTap: (){ 
        //   print('InforWindow');
        // }
      )
    );

    double kilometros = event.distancia / 1000;
    kilometros = ( kilometros * 100 ).floor().toDouble();
    kilometros = kilometros / 100;

    final markerDestino = new Marker(
      markerId: MarkerId('destino'),
      position: event.rutaCordenadas[ event.rutaCordenadas.length - 1] ,
       infoWindow: InfoWindow(
        title: event.nombreDestino,
        snippet: 'Distancia: $kilometros Km',
      )
    );

    final newMarkeres = { ...state.markers };
    newMarkeres['inicio'] = markerInicio;
    newMarkeres['destino'] = markerDestino;

    Future.delayed( Duration ( milliseconds: 300 ) ).then(
      (value){
        _mapController.showMarkerInfoWindow( MarkerId('inicio') );
        _mapController.showMarkerInfoWindow( MarkerId('destino') );

      }
    );


    yield state.copyWith(
      polylines: currentPolylines,
      markers: newMarkeres
    );
  }
}
