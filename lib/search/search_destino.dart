import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa/model/search_model.dart';
import 'package:mapa/services/trafico_servicios.dart';

class SearchDestino extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TraficoServicios _trafficService;
  final LatLng proximidad;

  SearchDestino(this.proximidad)
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
    this._trafficService.getResultadosQuery(this.query.trim(), proximidad);

    return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Colocar ubicacion manualmente'),
          onTap: () {
            print('Manualmente');
            this.close(context, SearchResult(cancelo: false, manual: true));
          },
        )
      ],
    );
  }
}
