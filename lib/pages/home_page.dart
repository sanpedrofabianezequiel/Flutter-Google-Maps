import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigationbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(
            onPressed: (){
              Provider.of<ScanListProvider>(context,listen: false)
                .borrarTodos();
            },
            icon:Icon(Icons.delete_forever),
          )
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked
    );
  }
}

class _HomePageBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final uiProvide = Provider.of<UiProvider>(context);

    final currentIndex = uiProvide.selectedMenuOpt;
    
    final tempScan =  new ScanModel(valor: 'http://google.com');
    //DBProvider.db.nuevoScan(tempScan); -------------> Insert!!!!!!!!!!!!!!!!!!!!!!!!!
    //DBProvider.db.getScanById(2).then((value) => print("Get values "+value.valor)); ---------> Get By Id!!!!!!!!!!!!!!!!!!!!!1111
    // DBProvider.db.getTodosLosScans().then((value) => print(value));
    //DBProvider.db.deleteAllScans().then((value) => print(value));
    
    //usar ScanListProvider
    final scanListProvider = Provider.of<ScanListProvider>(context,listen:false);
    
    
    switch (currentIndex) {
      case 0:
      scanListProvider.cargarScanPorTipo('geo');
        return MapasPage();
      case 1:
      scanListProvider.cargarScanPorTipo('http');
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}