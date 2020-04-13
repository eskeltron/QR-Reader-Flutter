import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/pages/otherData_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarTodos,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR( context ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

   _scanQR(BuildContext context) async {
     // geo:40.73463983551437,-73.85899916132816
     

    String futureString = '';

    try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }

    futureString = futureString.contains("FormatException") ? 'ERROR.' : futureString;

    if( futureString != null ) {

      final scan = ScanModel( valor: futureString);
      scansBloc.agregarScans(scan);

      if( Platform.isIOS ) {
        Future.delayed( Duration(milliseconds: 750), () {
          utils.abrirScan(scan, context);
        });
      }else{
        utils.abrirScan(scan, context);
      }
    }

  }

  Widget _callPage( int paginaActual ){

    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      case 2: return OtherDataPage();

      default: return MapasPage();
    }

  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text('Direcciones')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.text_fields ),
          title: Text('Otros')
        )
      ],
    );

  }
}