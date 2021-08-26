import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa/model/search_response.dart';
import 'package:mapa/model/trafficResponse.dart';

class TraficoServicios {
  //Singleton
  TraficoServicios._privateConstructor();
  static final TraficoServicios _instance =
      TraficoServicios._privateConstructor();
  factory TraficoServicios() {
    return _instance;
  }

  final _dio = new Dio();
  final baseurl = 'https://api.mapbox.com/directions/v5';
  final baseGeolocalizacion = 'https://api.mapbox.com/geocoding/v5';
  final apikey =
      'pk.eyJ1IjoiZGV2cm9kcmlnb2xvcGV6IiwiYSI6ImNrYzVuMXA0NjA2ejEycnFlZTdlNW15M2gifQ.t4EZfIvmGSTOxRRdSdm2Mg';

  Future<DrivingResponse> getCordsInicioFin(
      LatLng inicio, LatLng destino) async {
    print('Inicio $inicio');
    print('Fin $destino');

    final cordenadas =
        ' ${inicio.longitude}, ${inicio.latitude}; ${destino.longitude}, ${destino.latitude}';
    final url = '${this.baseurl}/mapbox/driving/$cordenadas';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this.apikey,
      'language': 'es',
    });

    // print(resp);
    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }

  Future<SearchResponse> getResultadosQuery(
      String busqueda, LatLng proximidad) async {
    final url = '${this.baseGeolocalizacion}/mapbox.places/$busqueda.json';

    final resp = await this._dio.get(url, queryParameters: {
      'access_token':
          'pk.eyJ1IjoiZGV2cm9kcmlnb2xvcGV6IiwiYSI6ImNrYzVuMXA0NjA2ejEycnFlZTdlNW15M2gifQ.t4EZfIvmGSTOxRRdSdm2Mg',
      'autocomplete': 'true',
      'proximity ': '${proximidad.latitude}, ${proximidad.latitude}',
      'language': 'es',
    });

    final searchresponse = searchResponseFromJson(resp.data);

    return searchresponse;
  }
}
