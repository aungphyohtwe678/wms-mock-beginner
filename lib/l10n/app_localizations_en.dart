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
  String get emergency_replenishment => 'Emergency\nReplenishment';

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
  String get emergency_source_location => 'Source Location';

  @override
  String get emergency_destination_location => 'Destination Location';

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

  @override
  String get pick_instruction_selection => 'Pick Instruction Selection';

  @override
  String get moto_location_area => 'Source Location Area';

  @override
  String get shelf_cs => 'Shelf CS';

  @override
  String get shelf_br => 'Shelf BR';

  @override
  String get skip => 'Skip';

  @override
  String get inventory_count => 'Inventory Count';

  @override
  String get inventory_location_scan => 'Check & Scan Inventory Locations';

  @override
  String get scan_location_barcode => 'Scan Location Barcode';

  @override
  String get scan_item_and_confirm_quantity => 'Scan Item & Confirm Quantity';

  @override
  String get beefreed_infusion_500ml_20bags => 'Beefreed Infusion 500mL × 20 bags';

  @override
  String get elneo_nf2_infusion_1000ml_10bags => 'Elneo NF2 Infusion 1000mL × 10 bags';

  @override
  String get scan_barcode => 'Scan Barcode';

  @override
  String get lot => 'Lot';

  @override
  String get confirm_quantity => 'Confirm Quantity';

  @override
  String get inventory_complete => 'Inventory Complete';

  @override
  String get loading_check => 'Loading Check';

  @override
  String get check_item_condition => 'Check Item Condition';

  @override
  String get check_rotation_and_tiers => 'Check Rotation & Tiers';

  @override
  String get cases => 'Case';

  @override
  String get cancel_inspection => 'Cancel Inspection';

  @override
  String get app_update => 'App Update';

  @override
  String get new_version_available => 'A new version is available';

  @override
  String get please_update_app => 'Please update the app';

  @override
  String get back_to_menu => 'Back to Menu';

  @override
  String otsuka_saline(Object number) {
    return 'Otsuka Saline ${number}mL';
  }

  @override
  String get beefreed => 'Beefreed';

  @override
  String kn_infusion(Object number1, Object number2) {
    return 'KN$number1 Infusion ${number2}mL';
  }

  @override
  String beefreed_with_number(Object number) {
    return 'Beefreed ${number}mL';
  }

  @override
  String beefreed_infusion_with_number(Object number) {
    return 'Beefreed Infusion ${number}mL';
  }

  @override
  String cases_full_pallet(Object number) {
    return '$number cases (Full Pallet)';
  }

  @override
  String get scan_asn_label => 'Scan ASN Label';

  @override
  String get issue_asn_label => 'Issue ASN Label';

  @override
  String get pick_complete => 'Pick Complete';

  @override
  String get stack_as_shown_in_figure => 'Stack as shown in the figure';

  @override
  String empty_pallet(Object number) {
    return 'Empty Pallet: $number piece';
  }

  @override
  String get pick_location => 'Pick Location';

  @override
  String box_size(Object size) {
    return 'Box Size: $size';
  }

  @override
  String get shooting_in_progress => 'Shooting...';

  @override
  String get otsuka_saline_syringe => 'Otsuka Saline Syringe';

  @override
  String get heparin_na_lock_syringe => 'Heparin Na Lock Syringe';

  @override
  String get camera_view => 'Camera View';

  @override
  String get transfer_destination => 'Transfer Destination';

  @override
  String get scan_elevator_qr => 'Scan Elevator QR Code';

  @override
  String get transfer_complete => 'Transfer Complete';

  @override
  String get storage_location => 'Storage Location';

  @override
  String get storage_complete => 'Storage Complete';
}
