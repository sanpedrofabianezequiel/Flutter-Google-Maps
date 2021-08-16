import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {

  int _selectedMenuopt= 0;
  
  int get selectedMenuOpt{
    return this._selectedMenuopt;
  }

  set selectedMenuOpt(int i){
    _selectedMenuopt = i;
    notifyListeners();
  }

}