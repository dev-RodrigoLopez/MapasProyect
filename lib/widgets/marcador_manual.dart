part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (context, state) {
      if (state.seleccionManuual) {
        return _MarcadorManual();
      } else {
        return Container();
      }
    });
  }
}

class _MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        //Boton Regresar
        Positioned(
            top: 70,
            left: 20,
            child: FadeInLeft(
              duration: Duration(milliseconds: 150),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    BlocProvider.of<BusquedaBloc>(context)
                        .add(OnDesactivarmarcadorManual());
                  },
                ),
              ),
            )),

        Center(
          child: Transform.translate(
              offset: Offset(0, -10),
              child: BounceInDown(
                  from: 200, child: Icon(Icons.location_on, size: 40))),
        ),

        //Boton de confirmar destino
        Positioned(
            bottom: 70,
            left: 40,
            child: FadeIn(
              child: MaterialButton(
                  child: Text('Confirmar destino',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.black,
                  minWidth: size.width - 120,
                  shape: StadiumBorder(),
                  elevation: 0,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    calcularDestino(context);
                  }),
            ))
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    final traficoServicios = new TraficoServicios();
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = BlocProvider.of<MapaBloc>(context).state.ubicacionCentral;

    calculandoAlerta(context);

    final traficResponse =
        await traficoServicios.getCordsInicioFin(inicio, destino);

    final geometry = traficResponse.routes[0].geometry;
    final duracion = traficResponse.routes[0].duration;
    final distancia = traficResponse.routes[0].distance;

    //Decodificar los puntos del Geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;

    final List<LatLng> coordsList =
        points.map((point) => LatLng(point[0], point[1])).toList();

    BlocProvider.of<MapaBloc>(context)
        .add(OnCrearRutaInicialDestino(coordsList, distancia, duracion));

    Navigator.of(context).pop();
    BlocProvider.of<BusquedaBloc>(context).add(OnDesactivarmarcadorManual());
  }
}
