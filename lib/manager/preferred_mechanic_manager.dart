import 'package:flutter/material.dart';
import 'package:untitled/model/preferred_mechanic_dto.dart';


class PreferredMechanicManager extends ChangeNotifier {
  List<PreferredMechanicDTO> _prefferedMechanicList = [];
  PreferredMechanicDTO? _selectedPreferredMechanicDTO;

  List<PreferredMechanicDTO> get preferredMechanicList => _prefferedMechanicList;
  PreferredMechanicDTO? get selectedPreferredMechanicDTO => _selectedPreferredMechanicDTO;

  set selectedPreferredMechanicDTO(PreferredMechanicDTO? preferredMechanicDTO) {
    _selectedPreferredMechanicDTO = preferredMechanicDTO;
    notifyListeners();
  }
  set preferredMechanicList(List<PreferredMechanicDTO> vendor) {
    _prefferedMechanicList = vendor;
    notifyListeners();
  }
}