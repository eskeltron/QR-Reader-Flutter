import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScan(ScanModel scan, BuildContext context) async {

  
    print( Navigator.of(context) );

  if( scan.tipo == 'http' || scan.tipo == 'HTTP' ){
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'No se puede abrir ${scan.valor}';
    }
  }else if (scan.tipo == 'geo' || scan.tipo == 'GEO') {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}