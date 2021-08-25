part of 'widgets.dart';

class BotonMiRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(Icons.remove_red_eye, color: Colors.black),
          onPressed: () {

            mapaBloc.add( OnMarcarRecorrido() );

          },
        ),
      ),
    );
  }
}
