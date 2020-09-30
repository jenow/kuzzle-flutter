import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mobile/bike_station.dart';

class Map extends StatefulWidget {
  List<BikeStation> stations;

  Map(this.stations);

  @override
  MapState createState() {
    return MapState(stations);
  }
}

class MapState extends State<Map> {
  List<BikeStation> stations;
  List<Marker> _markers = List<Marker>();

  MapState(this.stations);
  
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    for (BikeStation s in stations) {
      _markers.add(s.toWidget());
    }
    return FlutterMap(
      options: MapOptions(
        center: LatLng(43.6100166, 3.8518451),
        zoom: 14.0,
        maxZoom: 18,
      ),
      children: <Widget>[
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        MarkerLayerWidget(
          options: MarkerLayerOptions(
            markers: _markers,
          ),
        ),
      ],
    );
  }
}
