

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TraficoServicios {
    
  //Singleton
  TraficoServicios._privateConstructor();
  static final TraficoServicios _instance = TraficoServicios._privateConstructor();
  factory TraficoServicios(){
    return _instance;
  }

  final _dio = new Dio();
  final baseurl = 'https://api.mapbox.com/directions/v5';
  final apikey = 'pk.eyJ1IjoiZGV2cm9kcmlnb2xvcGV6IiwiYSI6ImNrYzVuMXA0NjA2ejEycnFlZTdlNW15M2gifQ.t4EZfIvmGSTOxRRdSdm2Mg';

   Future getCordsInicioFin ( LatLng inicio, LatLng destino ) async {
     print ('Inicio $inicio');
     print ('Fin $destino');

    final cordenadas = ' ${ inicio.longitude }, ${ inicio.latitude }; ${ destino.longitude }, ${ destino.latitude }';
    final url = '${ this.baseurl }/mapbox/driving/$cordenadas';

    final resp = await this._dio.get( url, queryParameters: {
      'alternatives'  : 'true',
      'geometries'    : 'polyline6',
      'steps'         : 'false',
      'access_token'  : this.apikey,
      'language'      : 'es',
    } );

    print( resp );

    return;

   }

}