part of 'helpers.dart';


Future<BitmapDescriptor> getAssetImageMarker() async{

  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(
      devicePixelRatio: 2.5
    ),
    'assets/custom-pin.png');

}

Future<BitmapDescriptor> getNetworkImageMarker() async {

  final resp = await Dio().get(
    'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
    options: Options( responseType: ResponseType.bytes )
  );

  // final bytes = resp.data;

  //Opcional
  // final image = await ui.instantiateImageCodec(bytes, targetHeight: 150, targetWidth: 150);
  // final frame = await imageCodec.getNextFrame();
  // final data = await frame.image.toByteData( format: ui.ImageByteFormat.png );
  // return await BitmapDescriptor.fromBytes( data.buffer.asUint8List() );
  return await BitmapDescriptor.fromBytes( resp.data );


}