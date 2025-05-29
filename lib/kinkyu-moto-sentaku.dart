import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/kinkyu-moto-cs1.dart';
import 'package:otk_wms_mock/kinkyu-moto-cs3.dart';
import 'package:otk_wms_mock/kinkyu-moto-pl.dart';

class KinkyuMotoSentakuScreen extends StatefulWidget {
  const KinkyuMotoSentakuScreen({super.key});

  @override
  State<KinkyuMotoSentakuScreen> createState() => _KinkyuMotoSentakuScreenState();
}

class _KinkyuMotoSentakuScreenState extends State<KinkyuMotoSentakuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<int, List<Map<String, dynamic>>> floorData = {
    0: [
      {'location': '01001 ', 'pl': 1, 'cs': 3, 'shelfBr': 1},
      {'location': '01002 ', 'pl': 0, 'cs': 1, 'shelfBr': 2},
    ],
    1: [
      {'location': '02002 ', 'pl': 2, 'cs': 1, 'shelfBr': 3},
      {'location': '02003 ', 'pl': 0, 'cs': 0, 'shelfBr': 1},
    ],
    2: [
      {'location': '03003 ', 'pl': 0, 'cs': 2, 'shelfBr': 0},
      {'location': '03004 ', 'pl': 0, 'cs': 0, 'shelfBr': 2},
    ],
    3: [
      {'location': '04004 ', 'pl': 1, 'cs': 0, 'shelfBr': 1},
      {'location': '04005 ', 'pl': 0, 'cs': 0, 'shelfBr': 0},
    ],
  };


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // 音声再生（画面表示後）
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/kinkyu-hozyu.ogg'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(40),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.5),
                        title: const Text(
                          '緊急補充指示選択',
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
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
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
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
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
                      body: Column(
                        children: [
                          // 戻るボタン
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.black),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(70, 48),
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                  ),
                                  child: const Text(
                                    '戻る',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 階数タブ（TabBar）
                          Container(
                            color: Colors.white,
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: Colors.black,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black54,
                              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(text: '1F'),
                                Tab(text: '2F'),
                                Tab(text: '3F'),
                                Tab(text: '4F'),
                              ],
                            ),
                          ),

                          // タブの中身（TabBarView）
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: List.generate(4, (index) {
                                return Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  child: _buildTable(floorData[index]!),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    )
                  )
            )
          )
        )
      )
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        _buildHeaderRow(),
        const Divider(color: Colors.black),
        ...data.asMap().entries.map((entry) => _buildDataRow(entry.key, entry.value)).toList(),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _tableHeaderCell('元ロケエリア'),
        _tableHeaderCell('PL→PL'),
        _tableHeaderCell('CS→PCS'),
        _tableHeaderCell('特CS→PCS'),
      ],
    );
  }

  Widget _buildDataRow(int index, Map<String, dynamic> row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tableCell(row['location']),
          _clickableCell(row['pl'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const KinkyuMotoPLScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _clickableCell(row['cs'].toString(), () {
            // if (index == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const KinkyuMotoCSScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            // } else if (index == 1) {
            //   Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //       pageBuilder: (_, __, ___) => const KinkyuMotoC2Screen(),
            //       transitionDuration: Duration.zero,
            //       reverseTransitionDuration: Duration.zero,
            //     ),
            //   );
            // }
          }),
          _clickableCell(row['shelfBr'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const KinkyuSakiCS3Screen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
        ],
      ),
    );
  }


  static Widget _tableHeaderCell(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }

  static Widget _tableCell(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }

  static Widget _clickableCell(String value, VoidCallback? onTap) {
    if (value == '0') {
      return _tableCell(value);
    }
    return GestureDetector(
      onTap: onTap,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontFamily: 'Helvetica Neue',
        ),
      ),
    );
  }
}
