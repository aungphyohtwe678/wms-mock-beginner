import 'package:flutter/material.dart';
import 'package:otk_wms_mock/main.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  // // タブごとのメニューリスト
  // final List<List<String>> _menuItems = [
  //   ['入荷', '入荷\n(バラ)', '搬送', '格納'], // 入荷
  //   ['緊急補充\n元ロケ出庫', '緊急補充\n先ロケ入庫', 'ピック開始', '梱包', '搬送', '荷合わせ', '荷捌き場\n設定'], // 出荷
  //   ['移動開始', '移動完了', 'ロケ移動', '棚移動'], // 移動
  //   ['ASN照会', 'ラベル\n再印刷', '棚卸', 'ダイレクト入庫',], // その他
  // ];

  // 搬送作業のみ
  final List<List<String>> _menuItems = [
    ['搬送'], // 入荷
    [], // 出荷
    [], // 移動
    ['ASN照会'], // その他
  ];

  // // 格納作業のみ
  // final List<List<String>> _menuItems = [
  //   ['格納'], // 入荷
  //   [], // 出荷
  //   [], // 移動
  //   ['ASN照会'], // その他
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景白
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'メニュー',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica Neue',
          ),
        ),
        centerTitle: true,
        actions: [
  PopupMenuButton<int>(
    icon: const Icon(Icons.person, color: Colors.white),
    offset: const Offset(0, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
  enabled: false,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        ' 一般作業者：山田 太郎',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Helvetica Neue',
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0); // 左から入る
                  const end = Offset.zero;
                  const curve = Curves.easeOut;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
              (Route<dynamic> route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // ★角丸
            ),
          ),
          child: const Text('ログアウト'),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // ポップアップ閉じる
            // アクシデント報告画面に遷移するなど
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // ★赤色ボタン
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // ★角丸
            ),
          ),
          child: const Text('アクシデント報告'),
        ),
      ),
    ],
  ),
),

    ],
  ),
],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2列
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: _menuItems[_selectedIndex].map((title) {
            return _buildMenuItem(title);
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Colors.black,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  items: [
    const BottomNavigationBarItem(
      icon: Icon(Icons.inbox),
      label: '入荷',
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.local_shipping, color: Colors.black),
      label: ''/*'出荷'*/,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.swap_horiz, color: Colors.black),
      label: '' /*'移動'*/,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.more_horiz),
      label: 'その他',
    ),
  ],
  type: BottomNavigationBarType.fixed,
),

    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () {
        // メニュータップ時の処理
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // ボタン背景：白
          border: Border.all(color: Colors.black, width: 2), // 枠線：黒
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black, // 文字色：黒
              fontSize: 18,
              fontFamily: 'Helvetica Neue',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
