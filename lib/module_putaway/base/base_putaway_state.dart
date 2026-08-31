import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/entity/prod_tag.dart';
import 'package:hz_xg_pda/http/LocApi.dart';
import 'package:hz_xg_pda/state/base_prod_tag_scan_state.dart';

abstract class BasePutawayState extends BaseProdTagScanState {
  BasePutawayState() {
    initLocList();
    loadCachedTags();
  }

  List<LocArchive> _locationOptions = <LocArchive>[];
  LocArchive? _selectedLocation;

  List<LocArchive> get locationOptions => _locationOptions;
  LocArchive? get selectedLocation => _selectedLocation;
  String get selectedLocationLabel => _selectedLocation?.locCode ?? '';

  Future<void> initLocList() async {
    final res = await LocApi.list();
    _locationOptions = res;
    if (_selectedLocation == null && _locationOptions.isNotEmpty) {
      _selectedLocation = _locationOptions.first;
    }
    notifyListeners();
  }

  void updateLocation(LocArchive? value) {
    if (value == null || value.id == _selectedLocation?.id) {
      return;
    }
    _selectedLocation = value;
    notifyListeners();
  }

  int get currentStep => 1;
}
