import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/addresses_page.dart';
import 'package:qrscanner/src/pages/maps_page.dart';
import 'package:qrscanner/src/utils/scan_utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _callPage(this.currentIndex),
      ),
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              scansBloc.deleteAllScans();
            },
            icon: Icon(Icons.delete_forever),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR() async {
    String futureString;
  
    try {
      futureString = await BarcodeScanner.scan();
    } catch(e) {
      futureString = e.toString();
    }
    
    if(futureString != null) {
      final newScan  = ScanModel(value: futureString);
      scansBloc.addScan(newScan);

      utils.openScan(context, newScan);
    }
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return AddressesPage();
      default:
        return MapsPage();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        setState(() {
          this.currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Maps')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Addresses'))
      ],
    );
  }
}
