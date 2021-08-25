import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mapa/bloc/mapa/mapa_bloc.dart';
import 'package:mapa/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import 'package:mapa/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();

    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => crearMapa(state)),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BotonUbicacion(),
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) return Center(child: Text('Ubicando...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnLocationUpdate(state.ubicacion));

    final camaraPosition =
        new CameraPosition(target: state.ubicacion, zoom: 15);

    return GoogleMap(
      initialCameraPosition: camaraPosition,
      mapType: MapType.normal,
      compassEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: mapaBloc.initMapa,
      zoomControlsEnabled: false,
    );

    // return Container(
    //   child: Center(
    //     child:
    //         Text('${state.ubicacion?.latitude}, ${state.ubicacion?.longitude}'),
    //   ),
    // );
  }
}
