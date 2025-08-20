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

  @override
  String get pick_instruction_selection => 'ピック指示選択';

  @override
  String get moto_location_area => '元ロケエリア';

  @override
  String get shelf_cs => '棚CS';

  @override
  String get shelf_br => '棚BR';

  @override
  String get skip => 'スキップ';

  @override
  String get inventory_count => '棚卸件数';

  @override
  String get inventory_location_scan => '棚卸対象ロケーション確認・スキャン';

  @override
  String get scan_location_barcode => 'ロケーションバーコードをスキャン';

  @override
  String get scan_item_and_confirm_quantity => '商品スキャン・数量確認';

  @override
  String get beefreed_infusion_500ml_20bags => 'ビーフリード輸液 500mL × 20袋';

  @override
  String get elneo_nf2_infusion_1000ml_10bags => 'エルネオパNF2号輸液 1000mL × 10袋';

  @override
  String get scan_barcode => 'バーコードをスキャン';

  @override
  String get lot => 'ロット';

  @override
  String get confirm_quantity => '数量確定';

  @override
  String get inventory_complete => '棚卸完了';

  @override
  String get loading_check => '積み付け確認';

  @override
  String get check_item_condition => '商品の状態を確認';

  @override
  String get check_rotation_and_tiers => '回し・段数確認';

  @override
  String get cases => 'ケース';

  @override
  String get cancel_inspection => '検品キャンセル';

  @override
  String get app_update => 'アプリ更新';

  @override
  String get new_version_available => '新しいバージョンがあります';

  @override
  String get please_update_app => 'アプリを更新してください';

  @override
  String get back_to_menu => 'メニューに戻る';

  @override
  String otsuka_saline(Object number) {
    return '大塚生食${number}ml';
  }

  @override
  String get beefreed => 'ビーフリード';

  @override
  String kn_infusion(Object number1, Object number2) {
    return 'KN$number1号輸液${number2}ml';
  }

  @override
  String beefreed_with_number(Object number) {
    return 'ビーフリード${number}ml';
  }

  @override
  String beefreed_infusion_with_number(Object number) {
    return 'ビーフリード輸液${number}ml';
  }

  @override
  String cases_full_pallet(Object number) {
    return '$numberケース（完パレ）';
  }

  @override
  String get scan_asn_label => 'ASNラベルをスキャン';

  @override
  String get issue_asn_label => 'ASNラベルを発行する';

  @override
  String get pick_complete => 'ピック完了';

  @override
  String get stack_as_shown_in_figure => '図のように積みつけ';

  @override
  String empty_pallet(Object number) {
    return '空パレット：$number枚';
  }

  @override
  String get pick_location => 'ピックロケーション';

  @override
  String box_size(Object size) {
    return '箱サイズ：$size';
  }
}
