import 'package:flutter/material.dart';
import 'package:kuzzle/kuzzle.dart';
import 'package:mobile/bike_station.dart';
import 'package:mobile/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuzzle & Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Kuzzle & Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BikeStation> stations = List<BikeStation>();
  Kuzzle kuzzle;

  @override
  void initState() {
    kuzzle = Kuzzle(
      WebSocketProtocol(
        Uri(
          scheme: 'ws',
          host: 'my-kuzzle-host',
          port: 7512,
        ),
      ),
    );

    kuzzle.connect().then((_) {
      kuzzle.query(KuzzleRequest(
        controller: 'bike-stations',
        action: 'get'
      )).then((res) {
        for (dynamic station in res.result['vcs']['sl']['si']) {
          setState(() {
            BikeStation bs = BikeStation(lat: station['la'], lng: station['lg'], total: station['to'], free: station['fr']);
            stations.add(bs);
          });
        }
      });

      kuzzle.realtime.subscribe('bike-stations', 'stations', {}, (message) {
        stations.clear();
        for (dynamic station in message.result['_source']['vcs']['sl']['si']) {
          setState(() {
            BikeStation bs = BikeStation(
              lat: station['la'],
              lng: station['lg'],
              total: station['to'],
              free: station['fr'],
            );
            stations.add(bs);
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Map(this.stations),
    );
  }
}
