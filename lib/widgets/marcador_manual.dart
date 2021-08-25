part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state){
        if( state.seleccionManuual ){
          return _MarcadorManual();
        }
        else{
          return Container();
        }
      }
    );
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
              icon: Icon( Icons.arrow_back, color: Colors.black, ),
              onPressed: (){
                 BlocProvider.of<BusquedaBloc>(context).add( OnDesactivarmarcadorManual() );
              },
            ),
          ),
        ) 
      ),

      Center(
        child: Transform.translate(
          offset: Offset( 0, -10 ),
          child: BounceInDown(
            from: 200,
            child: Icon( Icons.location_on, size: 40 )
          )
        ),
      ),

      //Boton de confirmar destino
      Positioned(
        bottom: 70,
        left: 40,
        child: FadeIn(
          child: MaterialButton(
            child: Text('Confirmar destino', style: TextStyle( color: Colors.white )),
            color: Colors.black,
            minWidth: size.width - 120,
            shape: StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: (){
              calcularDestino( context );
            }),
        )
      )

    ],
  );
  }


  void calcularDestino( BuildContext context ) async{
    final traficoServicios = new TraficoServicios();
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = BlocProvider.of<MapaBloc>(context).state.ubicacionCentral;

    await traficoServicios.getCordsInicioFin(inicio, destino);
    
  }

}

