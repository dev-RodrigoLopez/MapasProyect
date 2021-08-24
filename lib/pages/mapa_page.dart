import 'package:flutter/material.dart';
import 'package:mapa/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          builder: (context, state) => crearMapa(state)
        ),
      ),
    );
  }

  Widget crearMapa( MiUbicacionState state ){
    if( !state.existeUbicacion ) return Text('Ubicando...');

    return Container( 
        child: Center(
          child: Text('${ state.ubicacion?.latitude}, ${ state.ubicacion?.longitude }'),
        ), 
      );
  }

}