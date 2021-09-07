part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (context, state) {
      if (state.seleccionManuual) {
        return Container();
      } else {
        return FadeInDown(
            duration: Duration(milliseconds: 300),
            child: buildSearchbar(context));
      }
    });
  }

  Widget buildSearchbar(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: size.width,
        // height: 100,
        // color: Colors.red,
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: Center(
                child: Text(
              '¿A donde te diriges?',
              style: TextStyle(color: Colors.black54),
            )),
          ),
          onTap: () async {
            final proximidad =
                BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
                final historial = BlocProvider.of<BusquedaBloc>(context).state.historial;

            final SearchResult resultado = await showSearch(
                context: context, delegate: SearchDestino(proximidad, historial));
            this.retornoBusqueda(context, resultado);
          },
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async{

    if (result.cancelo) return;

    if (result.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }

    // calculandoAlerta(context);

    //Calcular la ruta en base al valor Result
    final traficoServicios = new TraficoServicios();
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final inicio =  BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = result.cordenadas;

    final drivingTraffic = await traficoServicios.getCordsInicioFin(inicio, destino);


    final geometry = drivingTraffic.routes[0].geometry;
    final duracion = drivingTraffic.routes[0].duration;
    final distancia = drivingTraffic.routes[0].distance;

    final point = Poly.Polyline.Decode( encodedString: geometry, precision: 6  );
    final List<LatLng> rutaCordenadas = point.decodedCoords.map(
      (point) => LatLng( point[0], point[1] )
    ).toList();

    mapaBloc.add( OnCrearRutaInicialDestino(rutaCordenadas, distancia, duracion) );

    // Navigator.pop(context);

    //Agregar al historial
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    busquedaBloc.add( OnAgregarHistorial( result ) );



  }
}
