import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qrscanner/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapCtrl = new MapController();
  String mapType = 'streets';
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () {
            mapCtrl.move(scan.getLatLng(), 15);
          },
        )
      ], title: Text('QR Coordinates')),
      body: _buildFlutterMap(scan),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  Widget _buildFlutterMap(ScanModel geoScan) {
    return FlutterMap(
        mapController: mapCtrl,
        options: MapOptions(center: geoScan.getLatLng(), zoom: 10),
        layers: [_buildMap(), _createMarkers(geoScan)]);
  }

  _buildMap() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiYXI0eiIsImEiOiJjazVueTh5NWwwNm02M2xuemVuNnR3czFtIn0.MmkmIW1aJfMaNZlpveDE3g',
          'id': 'mapbox.$mapType',
        });
  }

  _createMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (BuildContext context) => Container(
                child: Icon(Icons.location_on,
                    size: 60.0, color: Theme.of(context).primaryColor),
              ))
    ]);
  }

  FloatingActionButton _buildFloatingActionButtons(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat, color: Theme.of(context).primaryColor),
      onPressed: () {
        if (mapType == 'streets') {
          mapType = 'dark';
        } else if (mapType == 'dark') {
          mapType = 'light';
        } else if (mapType == 'light') {
          mapType = 'outdoors';
        } else if (mapType == 'outdoors') {
          mapType = 'satellite';
        } else {
          mapType = 'streets';
        }
        setState(() {});
      },
    );
  }
}
