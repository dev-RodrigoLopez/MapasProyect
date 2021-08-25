import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

class SearchResult {

  final bool cancelo;
  final bool manual;
  final LatLng cordenadas;
  final String nombreDestino;
  final String descripcion;

  SearchResult({
    @required this.cancelo, 
    this.manual, 
    this.cordenadas, 
    this.nombreDestino, 
    this.descripcion
  });

}