 import 'package:flutter/material.dart';
import 'package:mapa/customs_markers/custosm_markeres.dart';

 class TestMarkerPAge extends StatelessWidget {
 
   @override
   Widget build(BuildContext context) {
     return Scaffold(

       body: Center(
         child: Container(
           width: 350,
           height: 150,
          //  color: Colors.red,
           child: CustomPaint(

             painter: MarkerInicioPainter( 90 ),
            //  painter: MarkerDestinoPainter( 
            //    'Mi casa ubicada en Berirozabal, chiapas. Mexico',
            //    25000
            //   ),

           ),
         ),
        ),
       
     );
   }
 }