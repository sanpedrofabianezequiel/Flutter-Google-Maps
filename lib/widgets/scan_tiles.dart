import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/util/utils.dart';

class ScanTiles extends StatelessWidget {

  final String tipo;

  const ScanTiles({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final scanListProvider = Provider.of<ScanListProvider>(context);
  final scans =  scanListProvider.scans;//All data
    return ListView.builder(
      itemCount:scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction){
           Provider.of<ScanListProvider>(context,listen:false).borrarScanPorId(scans[i].id!);
        },
        child: ListTile(
          leading: Icon(
            this.tipo == 'http'
              ? Icons.home_outlined
              : Icons.map_outlined,
            color : Theme.of(context).primaryColor
          ),
          title: Text(scans[i].valor),
          subtitle: Text(scans[i].id.toString()),
          trailing: Icon(Icons.keyboard_arrow_right,color:Colors.grey),
          onTap: ()=> launchURL(context, scans[i]),
        ),
      ),
    );
  }
  
}