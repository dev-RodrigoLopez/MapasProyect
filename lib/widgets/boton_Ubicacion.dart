part of 'widgets.dart';

class BotonUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(Icons.my_location, color: Colors.black),
          onPressed: () {
            final destino = miUbicacionBloc.state.ubicacion;
            mapaBloc.moverCamara(destino);
          },
        ),
      ),
    );
  }
}
