// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'New WMS (Experienced User)';

  @override
  String get enter_password => 'Enter Password';

  @override
  String get access_password_hint => '16-digit access password';

  @override
  String get password_incorrect => 'Password is incorrect';

  @override
  String get new_wms => 'New WMS';

  @override
  String get username_email => 'Username (Email Address)';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get username_password_required => 'Please enter username and password.';

  @override
  String get email_format_error => 'Please enter a valid email address format.';

  @override
  String get menu_title => 'Menu';

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

  @override
  String get receiving => 'Receiving';

  @override
  String get shipping => 'Shipping';

  @override
  String get move => 'Move';

  @override
  String get others => 'Others';

  @override
  String get transport => 'Transport';

  @override
  String get storage => 'Storage';

  @override
  String get inspection => 'Inspection';

  @override
  String get emergency_replenishment => 'Emergency Replenishment';

  @override
  String get picking => 'Picking';

  @override
  String get shipping_transport => 'Transport (Shipping)';

  @override
  String get consolidation => 'Consolidation';

  @override
  String get sorting_area => 'Sorting Area';

  @override
  String get direct_movement => 'Direct Movement';

  @override
  String get work_status_search => 'Work Status Search';

  @override
  String get label_reprint => 'Label Reprint';

  @override
  String get inventory => 'Inventory';

  @override
  String get back => 'Back';

  @override
  String get receiving_transport => 'Transport (Receiving)';

  @override
  String get sorting => 'Sorting';

  @override
  String get storage_pl => 'Storage (PL)';

  @override
  String get storage_cs => 'Storage (CS)';

  @override
  String get storage_pcs => 'Storage (PCS)';

  @override
  String get stacking_confirmation => 'Stacking Confirmation (Bulk)';

  @override
  String get emergency_source_location => 'Emergency Replenishment (Source Location)';

  @override
  String get emergency_destination_location => 'Emergency Replenishment (Destination Location)';

  @override
  String get packing => 'Packing';

  @override
  String get no_instructions => 'No Instructions';

  @override
  String get system_error => 'System Error';

  @override
  String get update => 'Update';

  @override
  String get transport_menu => 'Transport Menu';

  @override
  String get storage_menu => 'Storage Menu';

  @override
  String get storage_pl_cs => 'Storage（PL／CS）';

  @override
  String get inspection_menu => 'Inspection Menu';

  @override
  String get emergency_replenishment_menu => 'Emergency Replenishment Menu';

  @override
  String get picking_menu => 'Picking Menu';
}
