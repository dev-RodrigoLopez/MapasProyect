part of 'widgets.dart';

class SearchBar extends StatelessWidget {

   @override
  Widget build(BuildContext context) {

      return BlocBuilder<BusquedaBloc, BusquedaState>(
        builder: (context, state){

          if( state.seleccionManuual )
          {
            return Container();

          }
          else{
            return FadeInDown(
              duration: Duration( milliseconds: 300 ),
              child: buildSearchbar( context )
            );
          }
        }
      );
  }


  Widget buildSearchbar(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 20 ),
        width: size.width,
        // height: 100,
        // color: Colors.red,
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 20, vertical: 13 ),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(100), 
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0,5)
                )
              ]
            ),
            child: Center(child: Text('¿A donde te diriges?', style: TextStyle( color: Colors.black54 ),)),
          ),
          onTap: ()async{
            print('Buscando');
            final SearchResult resultado = await showSearch(context: context, delegate: SearchDestino());
            this.retornoBusqueda(context, resultado);
            print(resultado);
          },
        ),
      ),
    );
  }


  void retornoBusqueda (BuildContext context, SearchResult result){


    print( 'Cancelo ${ result.cancelo }' );
    print( 'Manual ${ result.manual }' );
    if( result.cancelo  ) return;

    if( result.manual ){
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;

    }

  }

 
}