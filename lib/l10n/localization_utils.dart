import 'package:flutter/material.dart';
import 'app_localizations.dart';

class LocalizationUtils {
  /// 日本語ステップ名をローカライズされた文字列に変換
  static String translateStep(BuildContext context, String step) {
    step = step.trim();
    final loc = AppLocalizations.of(context)!;

    switch (step) {
      case '搬送済み':
        return loc.transported;
      case '検品済み':
        return loc.inspected;
      case '搬送待ち':
        return loc.waiting_for_transport;
      case '格納待ち':
        return loc.waiting_for_putaway;
      case '在庫':
        return loc.inventory;
      case '移動指示':
        return loc.transit_instruction;
      case '移動中':
        return loc.in_transit;
      case '移動完了':
        return loc.transit_complete;
      default:
        return step; // 未対応はそのまま表示
    }
  }
}