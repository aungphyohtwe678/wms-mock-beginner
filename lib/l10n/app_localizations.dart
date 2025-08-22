import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'New WMS (Experienced User)'**
  String get app_title;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enter_password;

  /// No description provided for @access_password_hint.
  ///
  /// In en, this message translates to:
  /// **'16-digit access password'**
  String get access_password_hint;

  /// No description provided for @password_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Password is incorrect'**
  String get password_incorrect;

  /// No description provided for @new_wms.
  ///
  /// In en, this message translates to:
  /// **'New WMS'**
  String get new_wms;

  /// No description provided for @username_email.
  ///
  /// In en, this message translates to:
  /// **'Username (Email Address)'**
  String get username_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username_password_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter username and password.'**
  String get username_password_required;

  /// No description provided for @email_format_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address format.'**
  String get email_format_error;

  /// No description provided for @menu_title.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_title;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @general_worker.
  ///
  /// In en, this message translates to:
  /// **'General Worker: {name}'**
  String general_worker(Object name);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @accident_report.
  ///
  /// In en, this message translates to:
  /// **'Accident Report'**
  String get accident_report;

  /// No description provided for @receiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get receiving;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @inspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspection;

  /// No description provided for @emergency_replenishment.
  ///
  /// In en, this message translates to:
  /// **'Emergency\nReplenishment'**
  String get emergency_replenishment;

  /// No description provided for @picking.
  ///
  /// In en, this message translates to:
  /// **'Picking'**
  String get picking;

  /// No description provided for @shipping_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport (Shipping)'**
  String get shipping_transport;

  /// No description provided for @consolidation.
  ///
  /// In en, this message translates to:
  /// **'Consolidation'**
  String get consolidation;

  /// No description provided for @sorting_area.
  ///
  /// In en, this message translates to:
  /// **'Sorting Area'**
  String get sorting_area;

  /// No description provided for @direct_movement.
  ///
  /// In en, this message translates to:
  /// **'Direct Movement'**
  String get direct_movement;

  /// No description provided for @work_status_search.
  ///
  /// In en, this message translates to:
  /// **'Work Status Search'**
  String get work_status_search;

  /// No description provided for @label_reprint.
  ///
  /// In en, this message translates to:
  /// **'Label Reprint'**
  String get label_reprint;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @receiving_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport (Receiving)'**
  String get receiving_transport;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @storage_pl.
  ///
  /// In en, this message translates to:
  /// **'Storage (PL)'**
  String get storage_pl;

  /// No description provided for @storage_cs.
  ///
  /// In en, this message translates to:
  /// **'Storage (CS)'**
  String get storage_cs;

  /// No description provided for @storage_pcs.
  ///
  /// In en, this message translates to:
  /// **'Storage (PCS)'**
  String get storage_pcs;

  /// No description provided for @stacking_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Stacking Confirmation (Bulk)'**
  String get stacking_confirmation;

  /// No description provided for @emergency_source_location.
  ///
  /// In en, this message translates to:
  /// **'Source Location'**
  String get emergency_source_location;

  /// No description provided for @emergency_destination_location.
  ///
  /// In en, this message translates to:
  /// **'Destination Location'**
  String get emergency_destination_location;

  /// No description provided for @packing.
  ///
  /// In en, this message translates to:
  /// **'Packing'**
  String get packing;

  /// No description provided for @no_instructions.
  ///
  /// In en, this message translates to:
  /// **'No Instructions'**
  String get no_instructions;

  /// No description provided for @system_error.
  ///
  /// In en, this message translates to:
  /// **'System Error'**
  String get system_error;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @transport_menu.
  ///
  /// In en, this message translates to:
  /// **'Transport Menu'**
  String get transport_menu;

  /// No description provided for @storage_menu.
  ///
  /// In en, this message translates to:
  /// **'Storage Menu'**
  String get storage_menu;

  /// No description provided for @storage_pl_cs.
  ///
  /// In en, this message translates to:
  /// **'Storage（PL／CS）'**
  String get storage_pl_cs;

  /// No description provided for @inspection_menu.
  ///
  /// In en, this message translates to:
  /// **'Inspection Menu'**
  String get inspection_menu;

  /// No description provided for @emergency_replenishment_menu.
  ///
  /// In en, this message translates to:
  /// **'Emergency Replenishment Menu'**
  String get emergency_replenishment_menu;

  /// No description provided for @picking_menu.
  ///
  /// In en, this message translates to:
  /// **'Picking Menu'**
  String get picking_menu;

  /// No description provided for @pick_instruction_selection.
  ///
  /// In en, this message translates to:
  /// **'Pick Instruction Selection'**
  String get pick_instruction_selection;

  /// No description provided for @moto_location_area.
  ///
  /// In en, this message translates to:
  /// **'Source Location Area'**
  String get moto_location_area;

  /// No description provided for @shelf_cs.
  ///
  /// In en, this message translates to:
  /// **'Shelf CS'**
  String get shelf_cs;

  /// No description provided for @shelf_br.
  ///
  /// In en, this message translates to:
  /// **'Shelf BR'**
  String get shelf_br;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @inventory_count.
  ///
  /// In en, this message translates to:
  /// **'Inventory Count'**
  String get inventory_count;

  /// No description provided for @inventory_location_scan.
  ///
  /// In en, this message translates to:
  /// **'Check & Scan Inventory Locations'**
  String get inventory_location_scan;

  /// No description provided for @scan_location_barcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Location Barcode'**
  String get scan_location_barcode;

  /// No description provided for @scan_item_and_confirm_quantity.
  ///
  /// In en, this message translates to:
  /// **'Scan Item & Confirm Quantity'**
  String get scan_item_and_confirm_quantity;

  /// No description provided for @beefreed_infusion_500ml_20bags.
  ///
  /// In en, this message translates to:
  /// **'Beefreed Infusion 500mL × 20 bags'**
  String get beefreed_infusion_500ml_20bags;

  /// No description provided for @elneo_nf2_infusion_1000ml_10bags.
  ///
  /// In en, this message translates to:
  /// **'Elneo NF2 Infusion 1000mL × 10 bags'**
  String get elneo_nf2_infusion_1000ml_10bags;

  /// No description provided for @scan_barcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scan_barcode;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @confirm_quantity.
  ///
  /// In en, this message translates to:
  /// **'Confirm Quantity'**
  String get confirm_quantity;

  /// No description provided for @inventory_complete.
  ///
  /// In en, this message translates to:
  /// **'Inventory Complete'**
  String get inventory_complete;

  /// No description provided for @loading_check.
  ///
  /// In en, this message translates to:
  /// **'Loading Check'**
  String get loading_check;

  /// No description provided for @check_item_condition.
  ///
  /// In en, this message translates to:
  /// **'Check Item Condition'**
  String get check_item_condition;

  /// No description provided for @check_rotation_and_tiers.
  ///
  /// In en, this message translates to:
  /// **'Check Rotation & Tiers'**
  String get check_rotation_and_tiers;

  /// No description provided for @cases.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get cases;

  /// No description provided for @cancel_inspection.
  ///
  /// In en, this message translates to:
  /// **'Cancel Inspection'**
  String get cancel_inspection;

  /// No description provided for @app_update.
  ///
  /// In en, this message translates to:
  /// **'App Update'**
  String get app_update;

  /// No description provided for @new_version_available.
  ///
  /// In en, this message translates to:
  /// **'A new version is available'**
  String get new_version_available;

  /// No description provided for @please_update_app.
  ///
  /// In en, this message translates to:
  /// **'Please update the app'**
  String get please_update_app;

  /// No description provided for @back_to_menu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get back_to_menu;

  /// No description provided for @otsuka_saline.
  ///
  /// In en, this message translates to:
  /// **'Otsuka Saline {number}mL'**
  String otsuka_saline(Object number);

  /// No description provided for @beefreed.
  ///
  /// In en, this message translates to:
  /// **'Beefreed'**
  String get beefreed;

  /// No description provided for @kn_infusion.
  ///
  /// In en, this message translates to:
  /// **'KN{number1} Infusion {number2}mL'**
  String kn_infusion(Object number1, Object number2);

  /// No description provided for @beefreed_with_number.
  ///
  /// In en, this message translates to:
  /// **'Beefreed {number}mL'**
  String beefreed_with_number(Object number);

  /// No description provided for @beefreed_infusion_with_number.
  ///
  /// In en, this message translates to:
  /// **'Beefreed Infusion {number}mL'**
  String beefreed_infusion_with_number(Object number);

  /// No description provided for @cases_full_pallet.
  ///
  /// In en, this message translates to:
  /// **'{number} cases (Full Pallet)'**
  String cases_full_pallet(Object number);

  /// No description provided for @issue_asn_label.
  ///
  /// In en, this message translates to:
  /// **'Issue ASN Label'**
  String get issue_asn_label;

  /// No description provided for @pick_complete.
  ///
  /// In en, this message translates to:
  /// **'Pick Complete'**
  String get pick_complete;

  /// No description provided for @stack_as_shown_in_figure.
  ///
  /// In en, this message translates to:
  /// **'Stack as shown in the figure'**
  String get stack_as_shown_in_figure;

  /// No description provided for @empty_pallet.
  ///
  /// In en, this message translates to:
  /// **'Empty Pallet: {number} piece'**
  String empty_pallet(Object number);

  /// No description provided for @pick_location.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pick_location;

  /// No description provided for @box_size.
  ///
  /// In en, this message translates to:
  /// **'Box Size: {size}'**
  String box_size(Object size);

  /// No description provided for @shooting_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Shooting...'**
  String get shooting_in_progress;

  /// No description provided for @otsuka_saline_syringe.
  ///
  /// In en, this message translates to:
  /// **'Otsuka Saline Syringe'**
  String get otsuka_saline_syringe;

  /// No description provided for @heparin_na_lock_syringe.
  ///
  /// In en, this message translates to:
  /// **'Heparin Na Lock Syringe'**
  String get heparin_na_lock_syringe;

  /// No description provided for @camera_view.
  ///
  /// In en, this message translates to:
  /// **'Camera View'**
  String get camera_view;

  /// No description provided for @transfer_destination.
  ///
  /// In en, this message translates to:
  /// **'Transfer Destination'**
  String get transfer_destination;

  /// No description provided for @scan_elevator_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan Elevator QR Code'**
  String get scan_elevator_qr;

  /// No description provided for @transfer_complete.
  ///
  /// In en, this message translates to:
  /// **'Transfer Complete'**
  String get transfer_complete;

  /// No description provided for @storage_location.
  ///
  /// In en, this message translates to:
  /// **'Storage Location'**
  String get storage_location;

  /// No description provided for @storage_complete.
  ///
  /// In en, this message translates to:
  /// **'Storage Complete'**
  String get storage_complete;

  /// No description provided for @waiting_for_transport.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Transport'**
  String get waiting_for_transport;

  /// No description provided for @waiting_for_putaway.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Putaway'**
  String get waiting_for_putaway;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @work_status_result.
  ///
  /// In en, this message translates to:
  /// **'Work Status Result'**
  String get work_status_result;

  /// No description provided for @item_code.
  ///
  /// In en, this message translates to:
  /// **'Item Code'**
  String get item_code;

  /// No description provided for @item_name.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get item_name;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @perform_putaway.
  ///
  /// In en, this message translates to:
  /// **'Perform Putaway'**
  String get perform_putaway;

  /// No description provided for @perform_transport.
  ///
  /// In en, this message translates to:
  /// **'Perform Transport'**
  String get perform_transport;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'　　Details'**
  String get details;

  /// No description provided for @inspected.
  ///
  /// In en, this message translates to:
  /// **'Inspected'**
  String get inspected;

  /// No description provided for @transported.
  ///
  /// In en, this message translates to:
  /// **'Transported'**
  String get transported;

  /// No description provided for @in_transit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get in_transit;

  /// No description provided for @transit_complete.
  ///
  /// In en, this message translates to:
  /// **'Transit Complete'**
  String get transit_complete;

  /// No description provided for @transit_instruction.
  ///
  /// In en, this message translates to:
  /// **'Transit Instruction'**
  String get transit_instruction;

  /// No description provided for @enter_label.
  ///
  /// In en, this message translates to:
  /// **'Please enter label'**
  String get enter_label;

  /// No description provided for @invalid_label.
  ///
  /// In en, this message translates to:
  /// **'Invalid label'**
  String get invalid_label;

  /// No description provided for @waiting_for_shipping_instruction.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Shipping Instruction'**
  String get waiting_for_shipping_instruction;

  /// No description provided for @waiting_for_picking.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Picking'**
  String get waiting_for_picking;

  /// No description provided for @shipping_complete.
  ///
  /// In en, this message translates to:
  /// **'Shipping Complete'**
  String get shipping_complete;

  /// No description provided for @asn_label_scan.
  ///
  /// In en, this message translates to:
  /// **'ASN Label Scan'**
  String get asn_label_scan;

  /// No description provided for @scan_asn_label.
  ///
  /// In en, this message translates to:
  /// **'Scan ASN Label'**
  String get scan_asn_label;

  /// No description provided for @check_work_status.
  ///
  /// In en, this message translates to:
  /// **'Check Work Status'**
  String get check_work_status;

  /// No description provided for @outer_code.
  ///
  /// In en, this message translates to:
  /// **'Outer Code'**
  String get outer_code;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @perform_transit.
  ///
  /// In en, this message translates to:
  /// **'Perform Transit'**
  String get perform_transit;

  /// No description provided for @transit_count.
  ///
  /// In en, this message translates to:
  /// **'Transit Count'**
  String get transit_count;

  /// No description provided for @source_location_scan.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Scan Source Location'**
  String get source_location_scan;

  /// No description provided for @item_scan.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Scan Item'**
  String get item_scan;

  /// No description provided for @case_count.
  ///
  /// In en, this message translates to:
  /// **'Case Count'**
  String get case_count;

  /// No description provided for @piece_count.
  ///
  /// In en, this message translates to:
  /// **'Piece Count'**
  String get piece_count;

  /// No description provided for @destination_location_scan.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Scan Destination Location'**
  String get destination_location_scan;

  /// No description provided for @inbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get inbound;

  /// No description provided for @outbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get outbound;

  /// No description provided for @pick_count.
  ///
  /// In en, this message translates to:
  /// **'Pick Count'**
  String get pick_count;

  /// No description provided for @prepare_empty_pallet.
  ///
  /// In en, this message translates to:
  /// **'Prepare Empty Pallet'**
  String get prepare_empty_pallet;

  /// No description provided for @sheet.
  ///
  /// In en, this message translates to:
  /// **'Sheets'**
  String get sheet;

  /// No description provided for @check_pick_location.
  ///
  /// In en, this message translates to:
  /// **'Check/Scan Pick Location'**
  String get check_pick_location;

  /// No description provided for @check_quantity_and_stack.
  ///
  /// In en, this message translates to:
  /// **'Confirm Quantity & Stacking'**
  String get check_quantity_and_stack;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
