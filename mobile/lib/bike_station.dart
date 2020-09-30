import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class BikeStation {
  final double lat;
  final double lng;
  final int total;
  final int free;

  BikeStation({
    this.lat,
    this.lng,
    this.total,
    this.free,
  });

  Marker toWidget() => Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(this.lat, this.lng),
        builder: (ctx) => Container(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: new Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${this.free}/${this.total}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  )),
            ],
          ),
        ),
      );
}
