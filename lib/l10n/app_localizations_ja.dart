// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get user_id => 'ユーザーID';

  @override
  String get voice_settings_here => '音声設定はこちら';

  @override
  String get password => 'パスワード';

  @override
  String get login => 'ログイン';

  @override
  String get inbound => '入荷';

  @override
  String get outbound => '出荷';

  @override
  String get outbound_equipment_qr_scan => '出荷機材QRスキャン';

  @override
  String get back => '戻る';

  @override
  String get qr_code => 'QRコード';

  @override
  String get scan_outbound_equipment_qr => '出荷機材のQRコードをスキャンしてください';

  @override
  String get auto_navigate_after_scan => 'スキャン後自動で次の画面に遷移します。';

  @override
  String get picking_pl_cs => 'ピッキング（PL/CS）';

  @override
  String get pick_count => 'ピック件数';

  @override
  String get prepare_empty_pallets => '空パレット用意';

  @override
  String empty_pallets_n_count(Object count) {
    return '空パレット$count枚';
  }

  @override
  String get pick_location_check_scan => 'ピックロケーション確認・スキャン';

  @override
  String get scan_location => 'ロケーションをスキャン';

  @override
  String get product_scan_qty_stacking => '商品スキャン・数量確認・積みつけ';

  @override
  String get scan_barcode => 'バーコードをスキャン';

  @override
  String get lot => 'ロット';

  @override
  String get asn_label_scan => 'ASNラベルスキャン';

  @override
  String get scan_asn_label => 'ASNラベルをスキャン';

  @override
  String get issue_asn_label => 'ASNラベル発行';

  @override
  String get picking_complete => 'ピック完了';

  @override
  String get menu => 'メニュー';

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
  String get sheet => '枚';

  @override
  String get cases => 'ケース';
}
