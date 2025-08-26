// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get user_id => 'User ID';

  @override
  String get voice_settings_here => 'Voice settings';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get inbound => 'Receiving';

  @override
  String get outbound => 'Shipping';

  @override
  String get outbound_equipment_qr_scan => 'Scan Shipping Equipment QR';

  @override
  String get back => 'Back';

  @override
  String get qr_code => 'QR Code';

  @override
  String get scan_outbound_equipment_qr => 'Please Scan the QR Code of the Shipping equipment';

  @override
  String get auto_navigate_after_scan => 'After scanning, the screen will automatically transition to the next page';

  @override
  String get picking_pl_cs => 'Picking (PL/CS)';

  @override
  String get pick_count => 'Pick Quantity';

  @override
  String get prepare_empty_pallets => 'Prepare Empty Pallet';

  @override
  String empty_pallets_n_count(Object count) {
    return '$count Empty Pallets';
  }

  @override
  String get pick_location_check_scan => 'Check and Scan Pick Location';

  @override
  String get scan_location => 'Scan Location';

  @override
  String get product_scan_qty_stacking => 'Scan Product, Confirm Quantity, Stack';

  @override
  String get scan_barcode => 'Scan barcode';

  @override
  String get lot => 'Lot';

  @override
  String get asn_label_scan => 'Scan ASN Label';

  @override
  String get scan_asn_label => 'Scan ASN Label';

  @override
  String get issue_asn_label => 'Issue ASN Label';

  @override
  String get picking_complete => 'Picking Complete';

  @override
  String get menu => 'Menu';

  @override
  String get notifications => 'Notifications';

  @override
  String general_worker(Object name) {
    return 'General Worker: $name';
  }

  @override
  String get logout => 'Logout';

  @override
  String get accident_report => 'Accident Report';
}
