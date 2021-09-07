import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa/model/search_model.dart';
import 'package:mapa/model/search_response.dart';
import 'package:mapa/services/trafico_servicios.dart';

class SearchDestino extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TraficoServicios _trafficService;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestino(this.proximidad, this.historial)
      : this.searchFieldLabel = 'Buscar',
        this._trafficService = new TraficoServicios();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () =>
            this.close(context, SearchResult(cancelo: true, manual: false)));
  }

  @override
  Widget buildResults(BuildContext context) {

    return this._construirResultadoSugerencias();

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if( this.query.length == 0 ){

      return ListView(
        children: [

          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manualmente'),
            onTap: () {
              print('Manualmente');
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          ),

          ...this.historial.map(
            ( result ) => ListTile(
              leading: Icon( Icons.history ),
              title: Text( result.nombreDestino ),
              subtitle: Text( result.descripcion ),
              onTap: (){
                this.close( context, result );
              },
            )
          ).toList()
          

        ],
      );
      
    }
    else{
      return this._construirResultadoSugerencias();
    }

  }

  Widget _construirResultadoSugerencias() { 

    if( this.query == 0 ){

      return Container();

    }
    
    this._trafficService.getSugerenciasPorQuery( this.query.trim(), proximidad );

    // this._trafficService.getResultadosQuery(this.query.trim(), proximidad)
    return StreamBuilder(
      stream: this._trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {  

        if( !snapshot.hasData ){
          return Center(child: CircularProgressIndicator());
        }

        final lugares = snapshot.data.features;

        if( lugares.length == 0 ){
          return Center(
            child: Icon( Icons.not_listed_location, size: 50,),
          );
        }

        return ListView.separated(
          separatorBuilder: ( _, i ) => Divider(), 
          itemCount: lugares.length,
          itemBuilder: ( _ , i){

            final lugar = lugares[i];
            return ListTile(

              leading: Icon( Icons.place ),
              title: Text( lugar.textEs ),
              subtitle: Text( lugar.placeNameEs ),
              onTap: (){

                print( lugar );
                this.close(context, SearchResult(
                  cancelo: false, 
                  manual: false,
                  cordenadas: LatLng( lugar.center[1], lugar.center[0] ),
                  nombreDestino: lugar.textEs,
                  descripcion: lugar.placeNameEs
                ));
              },

            );

          }, 
        );

      },
    );

  }

}
