import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController mapController = new MapController();

  String tipoActualMapa = 'streets';

  List<String> tiposDeMapa = ['dark', 'light', 'outdoors', 'satellite' ];

  @override
  Widget build(BuildContext context) {
    
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: () {
              mapController.move( scanModel.getLatLng(), 15.0);
            },
          )
        ],
      ),
      body: Center(
        child: _crearFlutterMap( scanModel ),
      ),
      floatingActionButton: _crearBotonFlotante( context ),
    );
  }

  Widget _crearFlutterMap( ScanModel scan) {

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15.0
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores( scan ),
      ],
    );

  }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiZXNrZWx0cm9uIiwiYSI6ImNrOGFnbHNmYjAxdHMzZXFzb3pkdmJjcm0ifQ.L9fy6yfNnTnrXq4_FoQU_Q',
        'id'          : 'mapbox.$tipoActualMapa' 
        // posibles valores para id = streets, dark, light, outdoors, satellite 
      }
      
    );

    

  }

  _crearMarcadores( ScanModel scan ){

      return MarkerLayerOptions(
        markers: <Marker> [
          Marker(
            width : 120.0,
            height: 120.0,
            point : scan.getLatLng(),
            builder: ( context ) => Container(
              child: Icon(
                Icons.location_on, 
                size: 60.0, 
                color: Theme.of(context).primaryColor
              ),
            ) 
          ),
        ]
      );

    }

  Widget _crearBotonFlotante( BuildContext context) {

    return FloatingActionButton(
      onPressed: () {
        setState(() {
          String aux = tipoActualMapa;
          tipoActualMapa = tiposDeMapa[0];
          tiposDeMapa.removeAt(0);
          tiposDeMapa.add(aux);
        });
      },
      child: Icon(Icons.find_replace),
      backgroundColor: Theme.of(context).primaryColor,
    );

  }
}