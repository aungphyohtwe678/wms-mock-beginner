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
  /// **'Emergency Replenishment'**
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
  /// **'Emergency Replenishment (Source Location)'**
  String get emergency_source_location;

  /// No description provided for @emergency_destination_location.
  ///
  /// In en, this message translates to:
  /// **'Emergency Replenishment (Destination Location)'**
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
