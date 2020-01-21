import 'dart:async';

import 'package:qrscanner/src/bloc/validator.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._();
  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._() {
    // get scans from db
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  addScan(ScanModel newScan) async {
    await DBProvider.db.newScan(newScan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScanById(id);
    getScans();
  }

  deleteAllScans() async {
    DBProvider.db.deleteScans();
    getScans();
  }
}
