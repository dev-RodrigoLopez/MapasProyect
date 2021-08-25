import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  // final _geolocator = new Geolocator();
  StreamSubscription<Geolocator.Position> _positionSubscription;

  void iniciarSeguimiento() {
    // final locationOptions = Geolocator.LocationOptions(
    //   accuracy: Geolocator.LocationAccuracy.high,
    //   distanceFilter: 10
    // );

    this._positionSubscription = Geolocator.Geolocator.getPositionStream(
            desiredAccuracy: Geolocator.LocationAccuracy.high,
            distanceFilter: 10)
        .listen((Geolocator.Position position) {
      final newLocation = new LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(newLocation));
    });
    // Geolocator.Geolocator.isLocationServiceEnabled();
  }

  void cancelarSeguimiento() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(
    MiUbicacionEvent event,
  ) async* {
    if (event is OnUbicacionCambio) {
      yield state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion);
    }
  }
}


// AIzaSyCBltddltg8moTJ5aW-bbmmdj_bMsL3vWk