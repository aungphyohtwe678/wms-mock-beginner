// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => '新WMS（経験者）';

  @override
  String get enter_password => 'パスワードを入力してください';

  @override
  String get access_password_hint => '16桁のアクセスパスワード';

  @override
  String get password_incorrect => 'パスワードが違います';

  @override
  String get new_wms => '新WMS';

  @override
  String get username_email => 'ユーザー名（メールアドレス）';

  @override
  String get password => 'パスワード';

  @override
  String get login => 'ログイン';

  @override
  String get username_password_required => 'ユーザー名とパスワードを入力してください。';

  @override
  String get email_format_error => '正しいメールアドレス形式で入力してください。';

  @override
  String get menu_title => 'メニュー';

  @override
  String get notifications => '通知';

  @override
  String general_worker(Object name) {
    return '一般作業者：$name';
  }

  @override
  String get logout => 'ログアウト';

  @override
  String get accident_report => 'アクシデント報告';

  @override
  String get receiving => '入荷';

  @override
  String get shipping => '出荷';

  @override
  String get move => '移動';

  @override
  String get others => 'その他';

  @override
  String get transport => '搬送';

  @override
  String get storage => '格納';

  @override
  String get inspection => '検品';

  @override
  String get emergency_replenishment => '緊急補充';

  @override
  String get picking => 'ピッキング';

  @override
  String get shipping_transport => '搬送（出荷）';

  @override
  String get consolidation => '荷合わせ';

  @override
  String get sorting_area => '荷捌き場';

  @override
  String get direct_movement => 'ダイレクト移動';

  @override
  String get work_status_search => '作業状況検索';

  @override
  String get label_reprint => 'ラベル再印刷';

  @override
  String get inventory => '棚卸';

  @override
  String get back => '戻る';

  @override
  String get receiving_transport => '搬送（入庫）';

  @override
  String get sorting => '仕分け';

  @override
  String get storage_pl => '格納（PL）';

  @override
  String get storage_cs => '格納（CS）';

  @override
  String get storage_pcs => '格納（PCS）';

  @override
  String get stacking_confirmation => '積み付け確認（バラ用）';

  @override
  String get emergency_source_location => '緊急補充（元ロケ出庫）';

  @override
  String get emergency_destination_location => '緊急補充（先ロケ入庫）';

  @override
  String get packing => '梱包';

  @override
  String get no_instructions => '指示なし';

  @override
  String get system_error => 'システムエラー';

  @override
  String get update => 'アップデート';

  @override
  String get transport_menu => '搬送メニュー';

  @override
  String get storage_menu => '格納メニュー';

  @override
  String get storage_pl_cs => '格納（PL／CS）';

  @override
  String get inspection_menu => '検品メニュー';

  @override
  String get emergency_replenishment_menu => '緊急補充メニュー';

  @override
  String get picking_menu => 'ピッキングメニュー';
}
