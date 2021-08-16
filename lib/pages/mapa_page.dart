import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType =  MapType.normal;


  @override
  Widget build(BuildContext context) {
    
    final ScanModel scan = ModalRoute.of(context)?.settings.arguments as ScanModel;  


    final CameraPosition puntoInicial = CameraPosition(
    target: scan.getLatLng(),
    zoom: 17,
    tilt:50
    );

    //Marcadores
    Set<Marker> markers =  new Set<Marker>();
    markers.add(new Marker(
      markerId: MarkerId('geo-location'),
      position: scan.getLatLng(),
    ));


    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions:[
          IconButton(
            icon: Icon(Icons.location_disabled),
            onPressed : ()async{
               final GoogleMapController controller = await _controller.future;
               controller.animateCamera(
                 CameraUpdate.newCameraPosition(
                   CameraPosition(
                     target: scan.getLatLng(),
                     zoom:17,
                     tilt: 50
                   )
                 ));
            }
          ),
        ]
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        markers:  markers,
        mapType: mapType,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton : Container(
        padding: EdgeInsets.only(right : 320,bottom:20),
        child: FloatingActionButton(
          child : Icon(Icons.layers),
          onPressed: (){
            setState(() {
                if(mapType == MapType.normal){
                  mapType = MapType.satellite;
                }else {
                  mapType = MapType.normal;
                }

            });
          }
        ),
      ),
    );
  }
}