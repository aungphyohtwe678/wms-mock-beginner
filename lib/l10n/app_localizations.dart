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

  /// No description provided for @user_id.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get user_id;

  /// No description provided for @voice_settings_here.
  ///
  /// In en, this message translates to:
  /// **'Voice settings'**
  String get voice_settings_here;

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

  /// No description provided for @inbound.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get inbound;

  /// No description provided for @outbound.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get outbound;

  /// No description provided for @outbound_equipment_qr_scan.
  ///
  /// In en, this message translates to:
  /// **'Scan Shipping Equipment QR'**
  String get outbound_equipment_qr_scan;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qr_code;

  /// No description provided for @scan_outbound_equipment_qr.
  ///
  /// In en, this message translates to:
  /// **'Please Scan the QR Code of the Shipping equipment'**
  String get scan_outbound_equipment_qr;

  /// No description provided for @auto_navigate_after_scan.
  ///
  /// In en, this message translates to:
  /// **'After scanning, the screen will automatically transition to the next page'**
  String get auto_navigate_after_scan;

  /// No description provided for @picking_pl_cs.
  ///
  /// In en, this message translates to:
  /// **'Picking (PL/CS)'**
  String get picking_pl_cs;

  /// No description provided for @pick_count.
  ///
  /// In en, this message translates to:
  /// **'Pick Quantity'**
  String get pick_count;

  /// No description provided for @prepare_empty_pallets.
  ///
  /// In en, this message translates to:
  /// **'Prepare Empty Pallet'**
  String get prepare_empty_pallets;

  /// No description provided for @empty_pallets_n_count.
  ///
  /// In en, this message translates to:
  /// **'{count} Empty Pallets'**
  String empty_pallets_n_count(Object count);

  /// No description provided for @pick_location_check_scan.
  ///
  /// In en, this message translates to:
  /// **'Check and Scan Pick Location'**
  String get pick_location_check_scan;

  /// No description provided for @scan_location.
  ///
  /// In en, this message translates to:
  /// **'Scan Location'**
  String get scan_location;

  /// No description provided for @product_scan_qty_stacking.
  ///
  /// In en, this message translates to:
  /// **'Scan Product, Confirm Quantity, Stack'**
  String get product_scan_qty_stacking;

  /// No description provided for @scan_barcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scan_barcode;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @asn_label_scan.
  ///
  /// In en, this message translates to:
  /// **'Scan ASN Label'**
  String get asn_label_scan;

  /// No description provided for @scan_asn_label.
  ///
  /// In en, this message translates to:
  /// **'Scan ASN Label'**
  String get scan_asn_label;

  /// No description provided for @issue_asn_label.
  ///
  /// In en, this message translates to:
  /// **'Issue ASN Label'**
  String get issue_asn_label;

  /// No description provided for @picking_complete.
  ///
  /// In en, this message translates to:
  /// **'Picking Complete'**
  String get picking_complete;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

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
