import 'package:latlong/latlong.dart';

class ScanModel {
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if ( this.valor.contains('http') || this.valor.contains('HTTP') ){
        this.tipo = 'http';
      }else if (this.valor.contains('geo') || this.valor.contains('GEO') ){
        this.tipo = 'geo';
      }else {
        this.tipo = 'other';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "tipo"  : tipo,
        "valor" : valor,
    };

    LatLng getLatLng(){
      final res = valor.substring(4).split(',');
      final latitud  = double.parse(res[0]);
      final longitud = double.parse(res[1]);

      return LatLng( latitud, longitud );
    }

}
