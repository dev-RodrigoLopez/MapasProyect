import 'package:flutter/material.dart';
import 'package:mapa/model/search_model.dart';

class SearchDestino  extends SearchDelegate<SearchResult>{

  @override
  final String searchFieldLabel;

  SearchDestino() : this.searchFieldLabel = 'Buscar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () => this.query = '' )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
      icon: Icon( Icons.arrow_back ),
      onPressed: () => this.close(context, SearchResult(cancelo: true, manual: false
      
      ))
    );
  }

  @override
  Widget buildResults(BuildContext context) {
     return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     return ListView(
       children: [
         ListTile(
           leading: Icon( Icons.location_on ),
           title: Text( 'Colocar ubicacion manualmente' ),
           onTap: (){
             print('Manualmente');
             this.close(context, SearchResult( cancelo: false, manual: true ) );
           },
         )
       ],
     );

  }



}