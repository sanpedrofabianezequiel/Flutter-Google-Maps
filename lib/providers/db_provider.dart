import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

import 'package:sqflite/sqflite.dart';

class DBProvider{

  static  Database? _database;
  static final DBProvider db = DBProvider._();//DBProvider._Provider();

  //Constructor private
  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database!;
    
    _database =  await initDB();

    return _database!;
  }

  Future<Database>initDB() async {
   Directory documentsDirectory = await  getApplicationDocumentsDirectory();
   final path =  join( documentsDirectory.path , 'ScansDB.db');  
   print(path);

   return await openDatabase(
     path,
     version: 1,
     onOpen: (db) {},
     onCreate:  (Database db , int version) async{
       await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipo TEXT,
          valor TEXT
        );
       ''');
     }
   );

  }

  Future<int> nuevoScanRaw(ScanModel nuevoscan) async {
    final id =  nuevoscan.id;
    final tipo =  nuevoscan.tipo;
    final valor = nuevoscan.valor;

    final db =  await database;

    final response = await db.rawInsert('''
      INSERT INTO Scans( id, tipo , valor)
            VALUES( $id, '$tipo' , '$valor')
    ''');
    return response;
  }


  Future<int>  nuevoScan(ScanModel nuevoscan) async{
    final db = await database;
    final res =  await db.insert('Scans', nuevoscan.toJson());
    print(res);//Id del ultimo registro cargado
    return res;
  }

  Future<ScanModel>  getScanById(int nuevoscan) async{
    final db = await database;
    final res =  await db.query('Scans', where : 'id = ?', whereArgs: [nuevoscan]);
    //print(res);//Id del ultimo registro cargado
    return res.isNotEmpty ?ScanModel.fromJson(res.first)  :  ScanModel.fromJson({});
  } 


  Future<List<ScanModel>>  getTodosLosScans() async{
    final db = await database;
    final res =  await db.query('Scans');
    //print(res);//Id del ultimo registro cargado
    return res.isNotEmpty 
      ? res.map((e) => ScanModel.fromJson(e)).toList() 
      : [];
  } 


  Future<List<ScanModel>>  getScansPorTipo(String tipo) async{
    final db = await database;
    final res =  await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');
    //print(res);//Id del ultimo registro cargado
    return res.isNotEmpty 
      ? res.map((e) => ScanModel.fromJson(e)).toList() 
      : [];
  } 

  Future<int> updateScan(ScanModel updateScan) async {
    final db = await database;
    final res = await db.update('Scans', updateScan.toJson(), where: 'id = ?', whereArgs: [updateScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async{
    final db =  await database;
    final res = await  db.delete('Scans',where:'id = ?', whereArgs: [id]);
    return res;
  }
  Future<int> deleteAllScans()async{
    final db = await  database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');
    return res;
  }
}